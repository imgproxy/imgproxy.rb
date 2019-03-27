module Imgproxy
  # Formats and regroups processing options
  class Options < Hash
    STRING_OPTS = %i[resizing_type gravity watermark_position style cachebuster format].freeze
    INT_OPTS = %i[width height quality watermark_x_offset watermark_y_offset].freeze
    FLOAT_OPTS = %i[dpr gravity_x gravity_y blur sharpen watermark_opacity watermark_scale].freeze
    BOOL_OPTS = %i[enlarge extend].freeze
    ARRAY_OPTS = %i[background preset].freeze
    ALL_OPTS = (STRING_OPTS + INT_OPTS + FLOAT_OPTS + BOOL_OPTS + ARRAY_OPTS).freeze

    OPTS_PRIORITY = %i[ resize size resizing_type width height dpr enlarge extend gravity quality
                        background blur sharpen watermark preset cachebuster ].freeze

    # @param options [Hash] raw processing options
    def initialize(options)
      merge!(options.slice(*ALL_OPTS))

      typecast

      group_resizing_opts
      group_gravity_opts
      group_watermark_opts

      encode_style

      replace(Hash[sort_by { |k, _| OPTS_PRIORITY.index(k) || 99 }])

      freeze
    end

    private

    def typecast
      compact.each do |key, value|
        self[key] =
          case key
          when *STRING_OPTS then value.to_s
          when *INT_OPTS then value.to_i
          when *FLOAT_OPTS then value.to_f
          when *BOOL_OPTS then bool(value)
          when *ARRAY_OPTS then wrap_array(value)
          end
      end
    end

    def bool(value)
      value && value != 0 && value != "0" ? 1 : 0
    end

    def wrap_array(value)
      value.is_a?(Array) ? value : [value]
    end

    def group_resizing_opts
      return unless self[:width] && self[:height]

      self[:size] = trim_nils(
        [delete(:width), delete(:height), delete(:enlarge), delete(:extend)],
      )

      self[:resize] = [delete(:resizing_type), *delete(:size)] if self[:resizing_type]
    end

    def group_gravity_opts
      gravity = trim_nils(
        [
          delete(:gravity),
          delete(:gravity_x),
          delete(:gravity_y),
        ],
      )

      self[:gravity] = gravity unless gravity[0].nil?
    end

    def group_watermark_opts
      watermark = trim_nils(
        [
          delete(:watermark_opacity),
          delete(:watermark_position),
          delete(:watermark_x_offset),
          delete(:watermark_y_offset),
          delete(:watermark_scale),
        ],
      )

      self[:watermark] = watermark unless watermark[0].nil?
    end

    def encode_style
      return if self[:style].nil?
      self[:style] = Base64.urlsafe_encode64(self[:style]).tr("=", "")
    end

    def trim_nils(value)
      value.delete_at(-1) while !value.empty? && value[-1].nil?
      value
    end
  end
end
