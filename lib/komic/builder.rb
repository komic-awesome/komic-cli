require 'komic/builder/pdf'
require 'komic/builder/douban_album'
require 'uri'

module Komic::Builder
  class Factory
    class << self
      def detect_type(string)
        path = File.join(Dir.pwd, string)
        r_douban_album = Regexp.new "www.douban.com/photos/album/"

        if string =~ URI::regexp and string =~ r_douban_album
          return 'douban_album'
        end

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
        when 'douban_album' then DoubanAlbum.new(type_string, options)
        end
      end
    end
  end
end
