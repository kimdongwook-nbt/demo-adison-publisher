module PubErrors
  class Base < StandardError
    attr_reader :code, :message

    def initialize(error)
      @code = error.code
      @message = error.message
    end
  end

  class Unauthenticated < Base
    def initialize(error = Errors::HMAC_NOT_AUTHENTICATED)
      super(error)
    end
  end

  class InvalidParameter < Base
    def initialize(error = Errors::INVALID_PARAMETERS)
      super(error)
    end
  end

  class InvalidUid < Base
    def initialize(error = Errors::INVALID_UID)
      super(error)
    end
  end

  class DuplicatedTrxId < Base
    def initialize(error = Errors::DUPLICATE_TRX_ID)
      super(error)
    end
  end

  class BadRequest < Base
    def initialize(error = Errors::BAD_REQUEST)
      super(error)
    end
  end
end
