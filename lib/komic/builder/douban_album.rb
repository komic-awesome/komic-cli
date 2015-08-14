require 'mechanize'
require 'fileutils'
require 'mime/types'
require 'tmpdir'
require 'komic/utils'

module Komic::Builder
  class DoubanAlbum
    attr_reader :images

    def initialize(type_string, options)
      @options = options
      @url = type_string
    end

    def images
      crawler = Crawler.new
      title, images = crawler.get_crawled_result(@url)
      images.map do |image_path|
        image = MiniMagick::Image.open(image_path)
        { src: image_path, width: image.width, height: image.height }
      end
    end
  end

  class DoubanAlbum::Crawler
    def initialize
      @mechanize = Mechanize.new
      @file_index = 0
      @tmpdir = Dir.mktmpdir
      @willbe_downloaded = []
    end

    def get_crawled_result(album_home_url)
      next_link_url = album_home_url
      next_link = nil
      album_title = nil

      @mechanize.get(album_home_url) do |page|
        album_title = page.at('title').text().strip!
      end

      loop do
        begin
          crawl_album_page(next_link_url)
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end

        @mechanize.get(next_link_url) do |page|
          next_link = page.at('link[rel="next"]')
        end
        break if next_link.nil?
        next_link_url = next_link["href"]
      end

      bar = Komic::Utils.create_progress("Download images from douban", \
        @willbe_downloaded.size)

      image_pathes = @willbe_downloaded.map do |url|
        image_path = download_image url
        bar.increment
        image_path
      end

      return album_title, image_pathes
    end

    def crawl_album_page(album_page_url)
      @mechanize.get(album_page_url) do |page|
        page.search('.photolst_photo').each do |link|
          crawl_photo_page(link['href'])
        end
      end
    end

    def crawl_photo_page(photo_page_url)
      link_to_large = nil
      thumb_photo_url = nil

      @mechanize.get(photo_page_url) do |page|
        link_to_large = page.at('a[title="查看原图"]')
        thumb_photo_url = page.at('.image-show-inner img')["src"]
      end

      unless link_to_large.nil?
        @mechanize.get(link_to_large['href']) do |page|
          @willbe_downloaded.push(page.at('#pic-viewer img')["src"])
        end
      else
        @willbe_downloaded.push(thumb_photo_url)
      end
    end

    def download_image(photo_url)
      resource = @mechanize.get(photo_url)
      content_type = resource["content-type"]
      mime_type = MIME::Types[resource["content-type"]].first
      image_path = File.expand_path( \
        [@file_index, mime_type.extensions.first].join('.'), @tmpdir)
      resource.save(image_path)
      @file_index = @file_index + 1
      sleep 2
      image_path
    end
  end
end
