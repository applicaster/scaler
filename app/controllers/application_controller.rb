class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  http_basic_authenticate_with(
    name: ENV.fetch("SCALER_USER"),
    password: ENV.fetch("SCALER_PASS"),
  )

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
end
