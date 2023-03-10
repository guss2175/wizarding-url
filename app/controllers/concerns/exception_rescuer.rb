module ExceptionRescuer
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found!
    rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity!
  end

  private

  def handle_record_not_found! exception
    render_not_found Errors::ActiveRecordNotFound.to_hash(exception)
  end

  def handle_unprocessable_entity! exception
    render_unprocessable_entity Errors::ActiveRecordValidation.to_hash(exception.record)
  end
end
