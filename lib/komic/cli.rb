require 'thor'
require 'komic/generator/generator'
require 'komic/builder'
require 'mini_magick'

module Komic
  # This module handles the Komic executables .
  class Cli < Thor

    desc "download URL", "从 url 下载画册数据 (* 目前只支持豆瓣相册)"
    option :name, default: "crawled_from_douban", desc: "设定文件夹名"
    def download(url)
      dev(url)
    end

    desc "version", "显示版本"
    def version
      say "Komic #{Komic::VERSION}"
      say "Komic's content.json version #{Komic::CONTENT_JSON_VERSION}"
    end

    desc "mock", "生成虚拟的画册数据"
    option :'page-number', default: 6, desc: "设定页数"
    option :'remote-url', default: false, desc: "是否让图片使用 https://placeimg.com/ 作为图片源"
    option :size, default: "700-1024x900-1000", desc: "设定尺寸"
    option :name, default: "mock", desc: "设定文件夹名"
    def mock
      generator = Komic::Generator.new
      mocks = generator.generate_mocks options
      generator.create_package({ images: mocks }, options)
    end

    desc "dev", '生成 dev 的数据'
    option :name, default: "dev", desc: "设定文件夹名"
    def dev(type_string)
      generator = Komic::Generator.new
      pdf_builder = Builder::Factory.get_builder(type_string, options)
      generator.create_package({ images: pdf_builder.images }, options)
    end

    desc "create", '生成网站'
    option :name, default: "dev", desc: "设定文件夹名"
    def create(type_string)
      generator = Komic::Generator.new
      builder = Builder::Factory.get_builder(type_string, options)
      generator.create_website({ images: builder.images }, options)
    end
  end
end
