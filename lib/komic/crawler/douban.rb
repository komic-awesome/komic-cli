require 'mechanize'
require 'fileutils'
require 'mime/types'
require 'tmpdir'

module Komic
  module Crawler
    class Douban
      def initialize
        @mechanize = Mechanize.new
        @file_index = 0
        @tmpdir = Dir.mktmpdir
      end

      def get_crawled_result(album_home_url)
        next_link_url = album_home_url
        next_link = nil

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

        return album_title, Dir.entries(@tmpdir) - %w[. ..]
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
            download_image(page.at('#pic-viewer img')["src"])
          end
        else
          download_image(thumb_photo_url)
        end
      end

      def download_image(photo_url)
        resource = @mechanize.get(photo_url)
        content_type = resource["content-type"]
        mime_type = MIME::Types[resource["content-type"]].first
        resource.save(File.expand_path( \
          [@file_index, mime_type.extensions.first].join('.'), @tmpdir))
        @file_index = @file_index + 1
        p 'current image is ' + @file_index.to_s
        sleep 2
      end
    end
  end
end
