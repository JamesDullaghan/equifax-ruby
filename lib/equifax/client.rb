module Equifax
  class Client
    class << self
      attr_accessor :account_number,
                    :password
    end

    attr_reader :url,
                :account_number,
                :password,
                :opts,
                :request_method,
                :request_params

    def initialize(url, opts = {}, request_params = {})
      @url = url or raise ArgumentError, 'URL Required to make a request'
      @account_number = Equifax::Client.account_number || ENV['EQUIFAX_ACCOUNT_NUMBER'] || opts[:account_number]
      @password = Equifax::Client.password || ENV['EQUIFAX_PASSWORD'] || opts[:password]
      @opts = opts.except(:account_number, :password, :request_method) if opts.any?
      @request_method = opts[:request_method]
      @request_params = request_params
    end

    def self.request(url, opts, request_params)
      client = Equifax::Client.new(url, opts, request_params)
      client.parsed_response
    end

    def post
      @request ||= Net::HTTP::Post.new(url)
      @request["content-type"] = 'application/xml'
      @request["cache-control"] = 'no-cache'
      @request.body = request_params
      @request
    end

    def http
      @http ||= Net::HTTP.new(url.host, url.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http
    end

    def req_method
      request_method.to_sym
    end

    def response
      @response ||= http.request(self.send(req_method))
    end

    def parsed_response
      @parsed_response ||= if xml
        JSON.parse(json, quirks_mode: true)
      end
    rescue JSON::ParserError => e
      LOGGER.error("Invalid response or unable to parse : #{e.inspect}")
    end

    def xml
      @xml ||= response.read_body
    end

    def json
      @json ||= Hash.from_xml(xml).to_json
    end
  end
end
