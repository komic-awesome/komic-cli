require 'komic/builder/pdf'
require 'komic/builder/zip'
require 'komic/builder/douban_album'
require 'uri'

module Komic::Builder
  IMAGE_SUFFIXES = ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'gif']
  FNMATCH_FOR_IMAGE = "**.{#{IMAGE_SUFFIXES.join(',')}}"
  class Factory
    class << self
      def detect_type(string)
        path = File.join(Dir.pwd, string)
        r_douban_album = Regexp.new "www.douban.com/photos/album/"

        if string =~ URI::regexp and string =~ r_douban_album
          return 'douban_album'
        end

        if File.exists?(path)
          file_extname = File.extname(path)
          if file_extname == '.pdf'
            return 'pdf'
          elsif file_extname == '.zip'
            return 'zip'
          end
        end
        raise "Builder can't be found."
      end

      def get_builder(type_string, options)
        case detect_type(type_string)
        when 'pdf' then PDF.new(type_string, options)
        when 'zip' then Zip.new(type_string, options)
        when 'douban_album' then DoubanAlbum.new(type_string, options)
        end
      end
    end
  end
end
