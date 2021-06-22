class ApplicationController < ActionController::API

  include Response
  include ExceptionHandler

  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_params, if: :devise_controller?

  protected

  def configure_permitted_params
    added_attrs = %i[first_name last_name username password_confirmation session]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :new_user_session, keys: added_attrs
  end

  # Config pagination header manually
  def set_pagination_header(name, options = {})
    scope = instance_variable_get("@#{name}")
    request_params = request.query_parameters
    url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
    url_without_params ||= request.original_url

    page = {}
    page[:first] = 1 if scope.total_pages > 1 && !scope.first_page?
    page[:last] = scope.total_pages  if scope.total_pages > 1 && !scope.last_page?
    page[:next] = scope.current_page + 1 unless scope.last_page?
    page[:prev] = scope.current_page - 1 unless scope.first_page?

    pagination_links = []
    page.each do |k, v|
      new_request_hash= request_params.merge({ :page => v })
      pagination_links << "<#{url_without_params}?#{new_request_hash.to_param}>; rel=\"#{k}\""
    end
    headers['Link'] = pagination_links.join(', ')
  end


end
