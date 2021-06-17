class ApplicationController < ActionController::API

 	include Response
  include ExceptionHandler

	include DeviseTokenAuth::Concerns::SetUserByToken

	before_action :configure_permitted_params, if: :devise_controller?

	protected

	def configure_permitted_params
		added_attrs = %i[first_name username]
		devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
		devise_parameter_sanitizer.permit :account_update, keys: added_attrs
	end
end
