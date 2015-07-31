require 'thor'
require 'komic/crawler/douban'

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
      p "#{__FILE__}"
      p "#{__dir__}"
      p Dir.pwd
    end
  end
end
