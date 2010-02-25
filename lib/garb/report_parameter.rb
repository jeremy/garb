module Garb
  class ReportParameter

    attr_reader :elements
    
    def initialize(name)
      @name = name
      @elements = []
    end
    
    def name
      @name.to_s
    end
    
    def <<(element)
      case element
      when nil
        # Ignore nil
      when Array
        @elements.concat element
      else
        @elements.push elements
      end
      self
    end
    
    def to_params
      value = self.elements.map{|param| Garb.to_google_analytics(param)}.join(',')
      value.empty? ? {} : {self.name => value}
    end
  end
end
