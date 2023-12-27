class ApplicationController < ActionController::Base

  def authenticate_hmac_headers
    x_hmac_datetime = request.headers[:X_HMAC_DATETIME] ? request.headers[:X_HMAC_DATETIME] : request.headers[:HTTP_X_HMAC_DATETIME]
    x_hmac_signature = request.headers[:X_HMAC_SIGNATURE] ? request.headers[:X_HMAC_SIGNATURE] : request.headers[:HTTP_X_HMAC_SIGNATURE]
    query_string = request.headers[:QUERY_STRING]
    raw_post_data = request.headers[:RAW_POST_DATA] ? request.headers[:RAW_POST_DATA] : request.headers[:HTTP_RAW_POST_DATA]
    request_method = request.headers[:REQUEST_METHOD]
    request_uri = request.headers[:REQUEST_URI]

    hmac_util = HmacUtil.new(HmacUtil::SupportAlgorithm::SHA256)
    is_valid = hmac_util.valid?(request_method, request_uri, x_hmac_datetime, query_string, raw_post_data, x_hmac_signature)
    logger.warn("Invalid HMAC Signature") unless is_valid

    @valid_hmac = is_valid
  end

end
