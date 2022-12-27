class Errors::ApplicationError < StandardError
  attr_reader :code, :message

  class << self
    def to_hash *args
      new(*args).to_hash
    end
  end

  def initialize code: nil, message: nil
    @code = code
    @message = message
  end

  def serialize
    [{code:, message:}]
  end

  def to_hash
    {success: false, errors: serialize}
  end
end
