

module Croesus
  autoload :ControllerHelpers, 'croesus/controller_helpers.rb'
  autoload :Mapping,           'croesus/mapping.rb'
  autoload :ModelHelpers,      'croesus/model_helpers.rb'
  autoload :OmniauthMapping,   'croesus/omniauth_mapping.rb'
  autoload :RouteHelpers,      'croesus/route_helpers.rb'
  
  module Presenters
    autoload :AuthCredentialPresenter, 'croesus/presenters/auth_credential_presenter.rb'
  end
  
  module ModelHelpers
    autoload :ModelConfig, 'croesus/model_helpers.rb'
  end
  
  module RouteHelpers
    autoload :Mapper, 'croesus/route_helpers.rb'
  end
  
  class Configuration
    include Singleton
    
    attr_accessor :providers, :default_scope
    attr_accessor :finished_setting_up_omniauth_apps
    
    def initialize
      @providers = []
      @default_scope = "user"
      @@finished_setting_up_omniauth_apps = false
    end
  end
  
  @@mappings = []
  @@omniauth_mappings = []
  
  def self.mappings
    @@mappings
  end
  
  def self.omniauth_mappings
    @@omniauth_mappings
  end
  
  def self.get_unused_omniauth_mapping
    @@omniauth_mappings.select { |mapping| !mapping.path_prefix.value }.first
  end
  
  def self.config(&block)
    yield Configuration.instance
    
    unless Configuration.instance.finished_setting_up_omniauth_apps
      number_of_croesus_resources = scan_routes_file
      add_omniauth_middleware_app_for_each_resource(number_of_croesus_resources)
    end
  end
  
  def self.add_mapping(resource, options)
    (@@mappings << Mapping.new(resource, options)).last
  end
  
  def self.add_new_omniauth_mapping
    (@@omniauth_mappings << OmniauthMapping.new).last
  end
  
  class Getter
    def initialize name
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end
  
  def self.ref(arg)
    if defined?(ActiveSupport::Dependencies::ClassCache)
      ActiveSupport::Dependencies::reference(arg)
      Getter.new(arg)
    else
      ActiveSupport::Dependencies.ref(arg)
    end
  end
  
  private
  
    class ResourcesCounter
      class Rails
        def self.application
          ResourcesCounter::Rails::Application.new
        end
        
        class Application
          def routes
            ResourcesCounter::Rails::Application::Routes.new
          end
          
          class Routes
            def draw(&block)
              yield block
            end
          end
        end
      end
      
      @croesus_resources_count = 0
      
      def self.croesus_resources_count
        @croesus_resources_count
      end
      
      def self.method_missing(method_sym, *arguments, &block)
        # NOOP
      end
      
      def self.croesus_for(*args)
        args.extract_options!
        @croesus_resources_count += args.count
      end
    end
  
    def self.scan_routes_file
      ResourcesCounter.class_eval(
        File.open(Rails.root.join("config","routes.rb"), 'r').read
      )
      
      ResourcesCounter.croesus_resources_count
    end
    
    def self.add_omniauth_middleware_app_for_each_resource(app_count)
      app_count.times do
        Rails.application.config.middleware.use ::OmniAuth::Builder do
          Configuration.instance.providers.each do |provider|
            ::Croesus.send("add_#{provider}_provider", self, Croesus.add_new_omniauth_mapping.path_prefix)
          end
        end
      end
    end
    
    def self.add_developer_provider(context, path_prefix)
      context.provider :developer, :fields => [:first_name, :last_name], :uid_field => :last_name, path_prefix: path_prefix
    end
    
    def self.add_facebook_provider(context, path_prefix)
      context.provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email', :display => 'popup', path_prefix: path_prefix
    end
end

require "croesus/engine"
require "croesus/controller_helpers"
require "croesus/route_helpers"
require "croesus/model_helpers"
require "croesus/omniauth_mapping"
require "croesus/mapping"

ActionController::Base.include Croesus::ControllerHelpers
ActionDispatch::Routing::Mapper.include Croesus::RouteHelpers::Mapper
ActiveRecord::Base.extend Croesus::ModelHelpers