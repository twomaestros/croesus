module Croesus
  class Mapping
    attr_reader :options, :scoped_path, :name, :path, :fullpath
    attr_reader :controllers, :path_names, :singular, :class_name
    
    def initialize(resource, options)
      @scoped_path = options[:as] ? "#{options[:as]}/#{resource}" : resource.to_s
      @singular = (options[:singular] || @scoped_path.tr('/', '_').singularize).to_sym

      @class_name = (options[:class_name] || resource.to_s.classify).to_s
      @klass = Croesus.ref(@class_name)

      @path = (options[:path] || resource).to_s
      @path_prefix = options[:path_prefix]

      @router_name = options[:router_name]      
      
      @options     = options
      @scoped_path = options[:as] ? "#{options[:as]}/#{resource}" : resource.to_s
      @name        = (options[:singular] || scoped_path.tr('/', '_').singularize).to_sym
      @fullpath    = "/#{@path_prefix}/#{@path}".squeeze("/")
      
      set_default_controllers
      set_default_path_names
    end
    
    def set_default_controllers
      mod = options[:module] || "croesus"
      @controllers = Hash.new { |h,k| h[k] = "#{mod}/#{k}" }
      @controllers.merge!(options[:controllers]) if options[:controllers]
      @controllers.each { |k,v| controllers[k] = v.to_s }
    end
    
    def set_default_path_names
      @path_names = Hash.new { |h,k| h[k] = k.to_s }
      @path_names.merge!(options[:path_names]) if options[:path_names]
    end
    
    def to
      @klass.get
    end
  end
end