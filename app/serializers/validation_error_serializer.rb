class ValidationErrorSerializer
  def initialize record, field, detail, message
    @record = record
    @field = field
    @detail = detail
    @message = message
  end

  def serialize
    {resource:, field:, code:, message:}
  end

  private

  attr_reader :message

  def resource
    I18n.t underscored_resource_name,
           scope: %i(api errors resources),
           default: underscored_resource_name
  end

  def field
    I18n.t @field,
           scope: [:api, :errors, :fields, underscored_resource_name],
           default: @field.to_s
  end

  def code
    I18n.t @detail,
           scope: %i(api errors code),
           default: @detail.to_s
  end

  def underscored_resource_name
    @record.class.to_s.gsub("::", "").underscore
  end
end
