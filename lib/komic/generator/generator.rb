require 'fileutils'
require 'tempfile'
require 'jbuilder'
require 'json'
require 'json-schema'
require 'mini_magick'
require 'base64'

require 'komic/version'
require 'komic/generator/helpers'

module Komic
  class ThumbnailsBuilder
    def initialize(files)
      @images = files
    end

    def render_sprite_symbol(props)
      id, mime_type, data, width, height = props.values

      return %(
        <symbol id="#{ id }">
          <image xlink:href="data:#{mime_type};base64,#{ data }"
            width="#{ width }" height="#{ height }"/>
        </symbol>
      )
    end

    def render_svg_sprite
      sprites = @images.map.with_index do |image, index|
          thumbnail = MiniMagick::Image.open(image[:src])
          thumbnail.resize "x200"
          thumbnail.format "jpeg"
          render_sprite_symbol({
            id: index,
            mime_type: thumbnail.mime_type,
            data: Base64.strict_encode64(thumbnail.to_blob),
            width: thumbnail.width,
            height: thumbnail.height
          })
        end

      return %(
        <svg xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink">
      ) + sprites.join(' ') + %(</svg>)
    end

    def to_build
      render_svg_sprite
    end
  end

  class ContentBuilder
    def initialize(meta, files)
      @meta = meta
      @images = files
    end

    def validate_json(data)
      data = JSON.load(data)
      schema = JSON.load(File.read(File.join(__dir__, './content.schema.json')))

      begin
          JSON::Validator.validate!(schema, data)
      rescue JSON::Schema::ValidationError
        puts $!.message
      end
    end

    def to_build
      content_builder = Jbuilder.new do |json|
        json.komic_cli_version Komic::VERSION
        json.content_json_version Komic::CONTENT_JSON_VERSION
        json.(@meta, :name, :author, :description, :thumbnails)
        json.images @images
      end
      data = content_builder.target!
      validate_json(data)
      return data
    end
  end

  class Generator

    def render_fake_svg(props)
      width, height = props.values

      return %(
        <svg width="#{ width }" height="#{ height }"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink">
          <rect width="100%" height="100%" fill="gray"></rect>
          <text x="#{ width / 2 }" y="50%" dy=".3em" text-anchor="middle"
            fill="white" font-size="30"
            font-family="Comic Sans, Comic Sans MS, cursive">
            #{ width } x #{ height }
          </text>
        </svg>
      )
    end

    def create_fake_image(filename, size)
      size = Helpers.parse_size(size)
      file = Tempfile.new([filename, '.svg'])
      image_width = size[:width]
      image_height = size[:height]
      file.write render_fake_svg({ width: image_width, height: image_height })
      file.close
      return { src: file.path, width: image_width, height: image_height }
    end

    def generate_mocks(options)
      images = Array.new(options[:'page-number'])
        .map.with_index do |value, index|
          create_fake_image index.to_s, options[:size]
        end
    end

    def create_package(data, options)
      root_dir = File.join(Dir.pwd, options[:name])
      image_dir = File.join(root_dir, 'images')

      [root_dir, image_dir].each { |path| FileUtils.mkdir_p path }

      files = data[:images]

      files.map.with_index do |image, index|
        image_manager = MiniMagick::Image.open(image[:src])

        image_path = File.join(image_dir, [index, image_manager.type.downcase].join('.'))
        FileUtils.mv image[:src], image_path
        image[:src] = image_path
        image
      end

      thumbnails_builder = ThumbnailsBuilder.new(files)
      thumbnail_path = File.join(image_dir, './thumbnail.svg')
      File.open(thumbnail_path, 'w') do |file|
        file.write thumbnails_builder.to_build
      end

      files.map do |image, index|
        image[:src] = Helpers.get_relativepath_as(image[:src], root_dir)
        image
      end

      meta = {
        description: 'TEST',
        name: 'TEST',
        author: { name: 'TEST' },
        thumbnails: {
          height: 200,
          path: Helpers.get_relativepath_as(thumbnail_path, root_dir),
        },
      }

      # TODO(yangqing): require deep_merge, dirty but work
      meta.merge!(data[:meta]) unless data[:meta].nil?

      content_builder = ContentBuilder.new(meta, files)
      File.open(File.join(root_dir, './content.json'), 'w') do |file|
        file.write content_builder.to_build
      end

    end
  end
end
