require 'faraday'
require 'faraday_middleware'

module PacklinkLite
  class Client
    def get(path, params = nil, options = {})
      with_error_handling do
        response = connection(options[:api_key]).get(path, params)
        response.body
      end
    end

    def post(path, payload, options = {})
      with_error_handling do
        response = connection(options[:api_key]).post(path, payload)
        response.body
      end
    end

    def delete(path, options = {})
      with_error_handling do
        response = connection(options[:api_key]).delete(path)
        response.body
      end
    end

    private

    def with_error_handling
      yield
    rescue Faraday::ClientError => e
      message = extract_error_message(e.response[:body]) || e.message
      raise(Error, message)
    end

    def connection(api_key)
      token = api_key || config.api_key
      raise(Error, 'API key is not set') if token.blank?

      (@connection ||= build_connection).tap do |conn|
        conn.headers['Authorization'] = token
      end
    end

    def build_connection
      Faraday.new(url: config.api_endpoint) do |builder|
        builder.options[:timeout] = config.timeout
        builder.options[:open_timeout] = config.timeout

        builder.request :retry
        builder.request :json

        builder.headers = config.headers

        builder.response :json, content_type: /\bjson$/
        builder.response :raise_error

        builder.adapter Faraday.default_adapter
      end
    end

    def extract_error_message(response_body)
      result = JSON.parse(response_body)
      result['message'] || result['messages']
    rescue JSON::ParserError
    end

    def config
      PacklinkLite.config
    end
  end
end
