module Converters
  class BaseConverter
    class << self
      def encode num, base
        return base_values(base)[0] if num.zero?

        result = ""
        while num.positive?
          result.prepend base_values(base)[num % base]
          num = (num / base).floor
        end

        result
      end

      def decode val, base
        base_10_num = 0
        digit = 0

        val.reverse.each_char do |char|
          num = base_values(base).index char
          base_10_num += num * (base**digit)
          digit += 1
        end

        base_10_num
      end

      def base_values base_key
        @base_values ||= Settings.converters.values["base_#{base_key}"]
      end
    end

    private_class_method :base_values
  end

  class Base62 < BaseConverter
    class << self
      def encode num
        super num, 62
      end

      def decode val
        super val, 62
      end
    end
  end
end
