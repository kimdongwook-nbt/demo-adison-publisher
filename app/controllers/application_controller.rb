class ApplicationController < ActionController::Base
  def validate_hmac_headers
    x_hmac_datetime = request.headers[:X_HMAC_DATETIME] || request.headers[:HTTP_X_HMAC_DATETIME]
    x_hmac_signature = request.headers[:X_HMAC_SIGNATURE] || request.headers[:HTTP_X_HMAC_SIGNATURE]
    query_string = request.headers[:QUERY_STRING]
    raw_post_data = request.raw_post
    request_method = request.headers[:REQUEST_METHOD]
    request_uri = request.headers[:REQUEST_URI]

    return false if [x_hmac_datetime, x_hmac_signature, raw_post_data, request_method, request_uri].any?(&:nil?)

    hmac_util = HmacUtil.new(HmacUtil::SupportAlgorithm::SHA256)
    is_valid = hmac_util.valid?(request_method, request_uri, x_hmac_datetime, query_string, raw_post_data, x_hmac_signature)
    logger.warn('Invalid HMAC Signature') unless is_valid

    is_valid
  end

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
