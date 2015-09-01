require 'tempfile'
require 'komic/utils'
require 'zip'


module Komic::Builder
  class Zip
    attr_reader :images

    def initialize(type_string, options)
      @options = options
      @zip_path = File.join(Dir.pwd, type_string)
    end

    def images
      images = []
      ::Zip::File.open(@zip_path) do |zip_file|
        zip_file.
          sort_by { |x| File.basename(x.name).split('.')[0].to_i }.
          select { |x| File.fnmatch?(FNMATCH_FOR_IMAGE, x.name, File::FNM_EXTGLOB) }.
          each do |entry|
            p entry.name
            will_be_write = Tempfile.new("#{ entry.name }")
            image = MiniMagick::Image.read(entry.get_input_stream.read)
            image.write will_be_write.path
            images.push({
              width: image.width, height: image.height, src: will_be_write
            })
          end
      end
      return images
    end
  end
end
