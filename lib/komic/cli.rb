require 'thor'
require 'komic/crawler/douban'
require 'komic/generator/generator'
require 'mini_magick'

module Komic
  # This module handles the Komic executables .
  class Cli < Thor

    map '-d' => :download

    desc "download URL", "从 url 下载画册数据 (* 目前只支持豆瓣相册)"
    option :name, default: "crawled_from_douban", desc: "设定文件夹名"
    def download(url)
      crawler = Komic::Crawler::Douban.new
      title, images = crawler.get_crawled_result(url)
      images = images.map do |image_path|
        image = MiniMagick::Image.open(image_path)
        { src: image_path, width: image.width, height: image.height }
      end
      generator = Komic::Generator.new
      generator.create_package({ images: images, meta: { name: title } }, options)
    end

    desc "mock", "生成虚拟的画册数据"
    option :'page-number', default: 6, desc: "设定页数"
    option :size, default: "700-1024x900-1000", desc: "设定尺寸"
    option :name, default: "mock", desc: "设定文件夹名"
    def mock
      generator = Komic::Generator.new
      mocks = generator.generate_mocks options
      generator.create_package({ images: mocks }, options)
    end
  end
end
