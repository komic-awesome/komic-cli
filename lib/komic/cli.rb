require 'thor'
require 'komic/crawler/douban'
require 'komic/generator/generator'

module Komic
  # This module handles the Komic executables .
  class Cli < Thor

    map '-d' => :download

    desc "download URL", "Download uri's images from url (* Only douban )"
    def download(url)
      crawler = Komic::Crawler::Douban.new
      title, files = crawler.get_crawled_result(url)
    end

    desc "test", "Test APP"
    def fake
    end

    desc "mock", "生成虚拟的画册数据"
    option :'page-number', default: 6, desc: "设定页数"
    option :size, default: "700-1024x900-1000", desc: "设定尺寸"
    option :name, default: "mock", desc: "设定文件夹名"
    def mock
      generator = Komic::Generator.new
      generator.generate_mock options
    end
  end
end
