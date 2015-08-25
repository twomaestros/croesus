require 'rails/generators/active_record'
require 'generators/croesus/orm_helpers'

module ActiveRecord
  module Generators
    class CroesusGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      
      include Croesus::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)
      
      def copy_croesus_migrations
        migration_template "auth_credentials_migration.rb", "db/migrate/croesus_create_auth_credentials.rb"
      end
      
      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end
      
      def inject_croesus_content
        content = model_contents
      
        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end
      
        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
      
        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
    end
  end
end