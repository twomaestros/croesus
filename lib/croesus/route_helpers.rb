require 'omniauth'

module Croesus::RouteHelpers
  module Mapper
    def croesus_for(*resources)
      options = resources.extract_options!

      options[:as]          ||= @scope[:as]     if @scope[:as].present?
      options[:module]      ||= @scope[:module] if @scope[:module].present?
      options[:path_prefix] ||= @scope[:path]   if @scope[:path].present?
      options[:path_names]    = (@scope[:path_names] || {}).merge(options[:path_names] || {})
      options[:constraints]   = (@scope[:constraints] || {}).merge(options[:constraints] || {})
      options[:defaults]      = (@scope[:defaults] || {}).merge(options[:defaults] || {})
      options[:options]       = @scope[:options] || {}
      options[:options][:format] = false if options[:format] == false

      resources.map!(&:to_sym)

      resources.each do |resource|
        mapping = Croesus.add_mapping(resource, options)

        croesus_scope mapping do
          with_croesus_exclusive_scope mapping.fullpath, mapping.name, options do
            draw_croesus_routes(mapping.fullpath, mapping.path_names, mapping.controllers)
          end
        end
      end
    end
    
    protected
    
      def croesus_scope(mapping)
        constraint = lambda do |request|
          request.env["croesus.mapping"] = mapping
          true
        end
      
        constraints(constraint) do
          yield
        end
      end
      alias :as :croesus_scope
      
      def with_croesus_exclusive_scope(new_path, new_as, options) #:nodoc:
        current_scope = @scope.dup
      
        exclusive = { as: new_as, path: new_path, module: nil }
        exclusive.merge!(options.slice(:constraints, :defaults, :options))
      
        exclusive.each_pair { |key, value| @scope[key] = value }
        yield
      ensure
        @scope = current_scope
      end
      
      def draw_croesus_routes(fullpath, path_names, controllers) #:nodoc:
        #get '/:provider/callback', controller: controllers[:callback], path: ""
        path_prefix = "#{fullpath}/#{path_names[:auth]}".squeeze('/')
        Croesus.get_unused_omniauth_mapping.path_prefix.value = path_prefix unless Croesus::Configuration.instance.finished_setting_up_omniauth_apps
        Croesus::Configuration.instance.finished_setting_up_omniauth_apps = true
        providers = Regexp.union(Croesus::Configuration.instance.providers.map(&:to_s))
        path, @scope[:path] = @scope[:path], nil
        
        match "#{path_prefix}/:provider",
          constraints: { provider: providers },
          to: "#{controllers[:auth_credentials]}#passthru",
          as: :omniauth_authorize,
          via: [:get, :post]

        match "#{path_prefix}/:provider/callback",
          constraints: { action: providers },
          to: "#{controllers[:auth_credentials]}#create",
          as: :omniauth_callback,
          via: [:get, :post]
      ensure
        @scope[:path] = path
      end
  end
end
