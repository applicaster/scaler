class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :set_current_timezone

  http_basic_authenticate_with(
    name: ENV.fetch("SCALER_USER"),
    password: ENV.fetch("SCALER_PASS"),
  )

  protected

  def set_current_timezone(&block)
    Time.use_zone(Settings.timezone, &block)
  end
end
