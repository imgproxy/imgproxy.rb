# frozen_string_literal: true

require "imgproxy/trim_array"

module Imgproxy
  module OptionsBuilders
    # Formats and regroups URL options
    class Base < Hash
      using TrimArray

      # Hash of options casters. Redefine this in subclases
      CASTERS = {}.freeze
      # Array of meta-options names. Redefine this in subclases
      META = [].freeze

      # @param options [Hash] raw options
      def initialize(options)
        super()

        # Options order hack: initialize known and meta options with nil value to preserve order
        self.class::CASTERS.each_key do |n|
          self[n] = nil if options.key?(n) || self.class::META.include?(n)
        end

        options.each do |name, value|
          caster = self.class::CASTERS[name]
          self[name] = caster ? caster.cast(value) : unwrap_hash(value)
        end

        group_opts

        compact!
      end

      private

      def unwrap_hash(raw)
        return raw unless raw.is_a?(Hash)

        raw.flat_map do |_key, val|
          unwrap_hash(val)
        end
      end

      def group_opts
        # Do nothing in the base class. Can be redefined in subclasses
      end

      def extract_and_trim_nils(*keys)
        keys.map { |k| delete(k) }.trim!
      end
    end
  end
end
