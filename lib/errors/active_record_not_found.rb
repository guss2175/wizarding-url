class Errors::ActiveRecordNotFound < Errors::ApplicationError
  attr_reader :model, :detail, :message_key

  def initialize error, message: nil
    @model = error.model.underscore
    @detail = error.class.to_s.split("::").last.underscore
    @message_key = message || :default
  end

  def serialize
    [
      {resource:, code:, message:}
    ]
  end

  private

  def message
    I18n.t message_key,
           scope: %i(api errors messages record_not_found),
           resource:
  end

  def resource
    I18n.t model,
           scope: %i(api errors resources),
           default: model
  end

  def code
    I18n.t detail,
           scope: %i(api errors code),
           default: detail
  end
end
