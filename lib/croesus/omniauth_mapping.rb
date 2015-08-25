module Croesus
  class OmniauthMapping
    attr_accessor :app, :path_prefix
    
    def initialize
      @path_prefix = PathPrefix.new
    end
    
    class PathPrefix
      attr_accessor :value
      
      def to_s
        @value
      end
    end
  end
end