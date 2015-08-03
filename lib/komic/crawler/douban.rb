require 'mechanize'
require 'fileutils'
require 'mime/types'
require 'tmpdir'
require 'ruby-progressbar'

module Komic
  module Crawler
    class Douban
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

        # green background
        color_code = "\e[0m\e[32m\e[7m\e[1m"
        reset_code = "\e[0m"
        progress_status = "#{color_code} %p%% #{reset_code}"

        bar = ProgressBar.create( :format         => "%a %bᗧ%i #{progress_status} %t",
                                  :title          => 'Download image from douban',
                                  :progress_mark  => ' ',
                                  :remainder_mark => '･',
                                  :total => @willbe_downloaded.size,
                                  :starting_at    => 0 )

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
end
