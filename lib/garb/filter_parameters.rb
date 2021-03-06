module Garb
  class FilterParameters
    def self.define_operators(*methods)
      methods.each do |method|
        class_eval <<-CODE
          def #{method}(field, value)
            self.parameters << {SymbolOperator.new(field, :#{method}) => value}
          end
        CODE
      end
    end

    define_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring

    attr_accessor :parameters

    def initialize
      self.parameters = []
    end

    def filters(&block)
      instance_eval &block
    end

    def to_params
      value = self.parameters.map do |param|
        param.map do |k,v|
          next unless k.is_a?(SymbolOperator)
          "#{URI.encode(k.to_google_analytics, /[=<>]/)}#{CGI::escape(v.to_s)}"
        end.join(',') # Hash AND
      end.join(';') # Array OR

      value.empty? ? {} : {'filters' => value}
    end
  end
end
