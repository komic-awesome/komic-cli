module Komic
  module Utils extend self
    # Merges a master hash with another hash, recursively.
    #
    # master_hash - the "parent" hash whose values will be overridden
    # other_hash  - the other hash whose values will be persisted after the merge
    #
    # This code was lovingly stolen from some random gem:
    # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
    #
    # Thanks to whoever made it.
    def deep_merge_hashes(master_hash, other_hash)
      target = master_hash.dup

      other_hash.each_key do |key|
        if other_hash[key].is_a? Hash and target[key].is_a? Hash
          target[key] = Utils.deep_merge_hashes(target[key], other_hash[key])
          next
        end

        target[key] = other_hash[key]
      end

      target
    end

    def parse_size(size)
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

    def get_relative_path(path, root)
      File.join('./',
        Pathname.new(path).relative_path_from(
          Pathname.new(root)
        ))
    end
  end
end
