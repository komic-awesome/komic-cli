require 'tempfile'
require 'mime/types'
require 'ruby-progressbar'

module Komic::Builder
  class PDF
    attr_reader :images

    def initialize(type_string, options)
      @options = options
      @pdf_path = File.join(Dir.pwd, type_string)
    end

    def images
      pdf = MiniMagick::Image.new(@pdf_path)

      # green background
      color_code = "\e[0m\e[32m\e[7m\e[1m"
      reset_code = "\e[0m"
      progress_status = "#{color_code} %p%% #{reset_code}"

      bar = ProgressBar.create( :format         => "%a %bᗧ%i #{progress_status} %t",
                                :title          => 'Download image from douban',
                                :progress_mark  => ' ',
                                :remainder_mark => '･',
                                :total => pdf.pages.size,
                                :starting_at    => 0 )

      pdf.pages.each_with_index.map do |page, idx|
        will_be_write = Tempfile.new("#{idx}").path
        page.write will_be_write
        image = MiniMagick::Image.open(will_be_write)
        image.format('jpg')
        image.interpolate('bicubic')
        image.quality(60)
        image.write Tempfile.new(["#{idx}", '.jpg']).path
        bar.increment
        { width: image.width, height: image.height, src: image.path }
      end
    end
  end
end
