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

    desc "test", "Test APP"
    def test
      generator = Komic::Generator.new
      generator.generate_fake
    end
  end
end
