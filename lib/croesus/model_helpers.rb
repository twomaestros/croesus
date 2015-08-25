module Croesus
  module ModelHelpers
    class ModelConfig
      attr_accessor :attributes, :scopes
    end
    
    attr_reader :croesus_config
        
    def croesus(opts = {})
      @croesus_config = ModelConfig.new
      
      has_many :auth_credentials, as: :authenticatable
      
      opts.keys.map!(&:to_sym)
      [:attributes, :scopes].each do |attrib|
        croesus_config.send("#{attrib}=", opts[attrib])
      end
      
      define_method :scopes do
        auth_credentials.active.inject([]) { |arr, cred| arr << cred.scopes; arr }.flatten.collect { |e| e.split(' ') }.flatten.uniq.join(' ')
      end
    end
  end
end