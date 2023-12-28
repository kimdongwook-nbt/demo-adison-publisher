# frozen_string_literal: true

require 'cgi'
require 'digest'
require 'openssl'
require 'base64'

class HmacUtil
  attr_accessor :secret_key, :algorithm

  module SupportAlgorithm
    SHA1 = 'sha1'
    SHA256 = 'SHA256'
  end

  # def initialize(secret_key, algorithm)
  #   @secret_key = secret_key
  #   @algorithm = algorithm
  # end

  def initialize(algorithm)
    @secret_key = 'test_pub_test_secret_key' # TODO: 환경 변수로 변경하기
    @algorithm = algorithm
  end

  def hmac_datetime
    Time.now.strftime('%FT%T%:z')
  end

  def signature(method, uri, hmac_datetime, encoded_query_string, payload)
    sign(string_to_sign(method, uri, hmac_datetime, encoded_query_string, payload))
  end

  def valid?(method, uri, hmac_date_time, encoded_query_string, payload, signature)
    generated_sign = signature(method, uri, hmac_date_time, encoded_query_string, payload)
    generated_sign == signature
    # not_expired = (Time.zone.now - hmac_datetime.to_datetime).to_i < 2.minutes.to_i
    # generated_sign && not_expired
  end

  private

  def sorted_query_string(encoded_query_string)
    parse_uri_query_string = CGI.parse(encoded_query_string)
    URI.encode_www_form(parse_uri_query_string.sort.to_h).gsub('+', '%20')
  end

  def payload_hash(payload)
    Digest::SHA256.hexdigest payload
  end

  def string_to_sign(method, uri, hmac_datetime, query_string, payload)
    "#{method}\n#{uri}\n#{hmac_datetime}\n#{sorted_query_string(query_string)}\n#{payload_hash(payload)}"
  end

  def sign(string_to_sign)
    raw_hmac = OpenSSL::HMAC.hexdigest(@algorithm, @secret_key, string_to_sign)
    Base64.strict_encode64(raw_hmac)
  end
end
