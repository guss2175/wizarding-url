class Api::V1::ApiController < ActionController::API
  include ExceptionRescuer

  prepend_before_action :set_locale

  Settings.http_status_codes.each do |type, status_code|
    define_method "render_#{type}" do |data|
      render json: data, status: status_code
    end
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym

    I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end
end
