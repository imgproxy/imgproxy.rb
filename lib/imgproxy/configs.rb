require "anyway_config"
require "imgproxy/config"

module Imgproxy
  # Imgproxy configs wrapper for different services
  #
  class Configs < Anyway::Config
    config_name :imgproxy

    attr_config(services: [])

    on_load :fill_services_override

    attr_reader :configs

    # Returns config by service name
    #
    # @param service_name [Symbol]
    # @return [Config]
    def [](service_name)
      configs[service_name] ||= Config.new
    end

    private

    def fill_services_override
      @configs = {}
      services.each do |service|
        next unless service["name"]

        @configs[service["name"].to_sym] = Config.new(service)
      end

      @configs[:default] = Config.new
    end
  end
end
