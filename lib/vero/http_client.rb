class Vero::HttpClient
  DEFAULT_HTTP_TIMEOUT = 60

  def initialize(http_timeout:, logger: nil)
    @http_timeout = http_timeout
    @logger = logger
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
    params = request_params(method, url, body, headers)

    log_request(params, body) if @logger

    req = RestClient::Request.new(params)
    req.execute
  end

  private

  def request_params(method, url, body = nil, headers = {})
    params = {method: method, url: url, headers: default_headers.merge(headers), timeout: @http_timeout}
    params[:payload] = JSON.dump(body) unless method == :get

    params
  end

  def default_headers
    {content_type: :json, accept: :json}
  end

  def log_request(params, body)
    # Clone params to avoid modifying the original
    log_params = params.dup

    if log_params.key?(:payload)
      log_params[:payload] = Vero::App.sanitize_log_payload(body).to_json
    end

    @logger.info("Request: #{log_params.inspect}")
  end
end
