require 'pathname'

module Komic
  class Generator
    module Helpers
      def self.get_relativepath_as(path, root)
        File.join('./',
          Pathname.new(path).relative_path_from(
            Pathname.new(root)
          ))
      end
    end
  end
end
