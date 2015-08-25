require 'rails/generators/named_base'

module Croesus
  module Generators
    class CroesusGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace "croesus"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with croesus " <<
           "configuration plus a migration file and croesus routes."
      
      hook_for :orm
      
      def add_croesus_routes
        croesus_route  = "croesus_for :#{plural_name}"
        croesus_route << %Q(, class_name: "#{class_name}") if class_name.include?("::")
        croesus_route << %Q(, skip: :all) unless options.routes?
        route croesus_route
      end
      
      def copy_croesus_initializer
        template "croesus_initializer.rb", "config/initializers/croesus.rb"
      end
    end
  end
end