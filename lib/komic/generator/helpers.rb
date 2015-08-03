require 'pathname'

module Komic
  class Generator
    module Helpers
      def self.parse_size(size)
        width_range, height_range = size.split('x')
        width, height = [width_range, height_range].map do |range|
          unless range.nil?
            min, max = range.split('-')
            r = range.to_i
            unless max.nil?
              r = Random.rand(min.to_i...max.to_i)
            end
            r
          end
        end
        return { width: width, height: height }
      end

      def self.get_relativepath_as(path, root)
        File.join('./',
          Pathname.new(path).relative_path_from(
            Pathname.new(root)
          ))
      end
    end
  end
end
