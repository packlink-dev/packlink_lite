module PacklinkLite
  class Configuration
    attr_reader :headers
    attr_writer :api_endpoint
    attr_accessor :api_key, :timeout

    def initialize
      @headers = { 'Content-Type' => 'application/json' }
    end

    def api_endpoint
      @api_endpoint || 'https://api.packlink.com/v1/'
    end

    def timeout
      @timeout || 60
    end

    def headers=(options)
      headers.merge!(options)
    end
  end
end
