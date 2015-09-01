require 'tempfile'
require 'komic/utils'
require 'zip'

module Komic::Builder
  class Directory
    attr_reader :images

    def initialize(type_string, options)
      @options = options
      @path = File.join(Dir.pwd, type_string)
    end

    def images
      images = []
      Dir.glob(File.join(@path, FNMATCH_FOR_IMAGE)).
        sort_by { |x| File.basename(x).split('.')[0].to_i }.
        each_with_index do |entry_path, index|
          will_be_write = Tempfile.new("#{ File.basename(entry_path) }")
          image = MiniMagick::Image.open(entry_path)
          image.write will_be_write.path
          images.push({
            width: image.width, height: image.height, src: will_be_write
          })
        end
      return images
    end
  end
end
