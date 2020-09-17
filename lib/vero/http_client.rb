class Vero::HttpClient
  DEFAULT_HTTP_TIMEOUT = 60

  def initialize(http_timeout:, logger: nil)
    @http_timeout = http_timeout
    setup_logging!(logger) if logger
  end

  def get(url, headers = {})
    do_request(:get, url, nil, headers)
  end

  def post(url, body, headers = {})
    do_request(:post, url, body, headers)
  end

  def put(url, body, headers = {})
    do_request(:put, url, body, headers)
  end

  def do_request(method, url, body = nil, headers = {})
    request_params = {method: method, url: url, headers: default_headers.merge(headers), timeout: @http_timeout}
    request_params[:payload] = JSON.dump(body) unless method == :get
    RestClient::Request.execute(request_params)
  end

  private

  def default_headers
    {content_type: :json, accept: :json}
  end

  def setup_logging!(logger)
    RestClient.log = Object.new.tap do |proxy|
      def proxy.<<(message)
        logger.info message
      end
    end
  end
end
