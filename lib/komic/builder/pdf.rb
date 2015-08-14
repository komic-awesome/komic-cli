require 'tempfile'
require 'mime/types'
require 'ruby-progressbar'
require 'komic/utils'

module Komic::Builder
  class PDF
    attr_reader :images

    def initialize(type_string, options)
      @options = options
      @pdf_path = File.join(Dir.pwd, type_string)
    end

    def images
      pdf = MiniMagick::Image.new(@pdf_path)

      bar = Komic::Utils.create_progress("Extract images from pdf", pdf.pages.size)

      pdf.pages.each_with_index.map do |page, idx|
        will_be_write = Tempfile.new("#{idx}").path
        page.write will_be_write
        image = MiniMagick::Image.open(will_be_write)
        image.format('jpg')
        image.write Tempfile.new(["#{idx}", '.jpg']).path
        bar.increment
        { width: image.width, height: image.height, src: image.path }
      end
    end
  end
end
