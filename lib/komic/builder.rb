require 'komic/builder/pdf'

module Komic::Builder
  class Factory
    class << self
      def detect_type(string)
        path = File.join(Dir.pwd, string)
        if File.exists?(path)
          if File.extname(path) == '.pdf'
            return 'pdf'
          end
        end
        raise "Builder can't be found."
      end

      def get_builder(type_string, options)
        case detect_type(type_string)
        when 'pdf' then PDF.new(type_string, options)
        end
      end
    end
  end
end
