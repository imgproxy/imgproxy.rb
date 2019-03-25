require 'ostruct'

module Imgproxy
  # Formats and regroups processing options
  class Options < Hash
    STRING_OPTS = %i[resizing_type gravity watermark_position cachebuster
                     format].freeze

    INT_OPTS = %i[width height quality watermark_x_offset
                  watermark_y_offset].freeze

    FLOAT_OPTS = %i[dpr gravity_x gravity_y blur sharpen watermark_opacity
                    watermark_scale].freeze

    BOOL_OPTS = %i[enlarge extend].freeze

    ARRAY_OPTS = %i[background preset].freeze

    ALL_OPTS =
      (STRING_OPTS + INT_OPTS + FLOAT_OPTS + BOOL_OPTS + ARRAY_OPTS).freeze

    OPTS_PRIORITY = { resize: 1, size: 2 }.freeze

    # @param options [Hash] raw processing options
    def initialize(options)
      merge!(options.slice(*ALL_OPTS))
      typecast
      freeze
    end

    # @return [Hash] formatted and regrouped processing options
    def build
      opts = dup

      group_resizing_opts(opts)
      group_gravity_opts(opts)
      group_watermark_opts(opts)

      Hash[opts.sort_by { |k, _| OPTS_PRIORITY.fetch(k, 99) }]
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
      value && value != 0 && value != '0' ? 1 : 0
    end

    def wrap_array(value)
      value.is_a?(Array) ? value : [value]
    end

    def group_resizing_opts(opts)
      return opts unless opts[:width] && opts[:height]

      opts[:size] = trim_nils(
        [opts.delete(:width), opts.delete(:height),
         opts.delete(:enlarge), opts.delete(:extend)]
      )

      if opts[:resizing_type]
        opts[:resize] = [opts.delete(:resizing_type), *opts.delete(:size)]
      end

      opts
    end

    def group_gravity_opts(opts)
      gravity = trim_nils(
        [
          opts.delete(:gravity),
          opts.delete(:gravity_x),
          opts.delete(:gravity_y)
        ]
      )

      opts[:gravity] = gravity unless gravity[0].nil?
    end

    def group_watermark_opts(opts)
      watermark = trim_nils(
        [
          opts.delete(:watermark_opacity),
          opts.delete(:watermark_position),
          opts.delete(:watermark_x_offset),
          opts.delete(:watermark_y_offset),
          opts.delete(:watermark_scale)
        ]
      )

      opts[:watermark] = watermark unless watermark[0].nil?
    end

    def trim_nils(value)
      value.delete_at(-1) while !value.empty? && value[-1].nil?
      value
    end
  end
end
