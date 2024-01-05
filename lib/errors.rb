module Errors
  class ErrorItem
    attr_reader :code, :message

    def initialize(code, message)
      @code = code
      @message = message
    end
  end

  HMAC_NOT_AUTHENTICATED = ErrorItem.new("101", "HMAC 인증 오류")
  INVALID_PARAMETERS = ErrorItem.new("102", "파라미터 오류")
  INVALID_UID = ErrorItem.new("103", "올바르지 않은 uid")
  DUPLICATED = ErrorItem.new("104", "중복 호출")
  BAD_REQUEST = ErrorItem.new("400", "기타 오류")
end
