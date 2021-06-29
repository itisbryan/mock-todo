# frozen_string_literal: true
module RequestSpecHelper

  def login(user)
    post '/auth/sign_in',
         params: { email: user.email, password: 'password' }.to_json,
         headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token_type' => token_type
    }
  end

  # Get correct form of requested object based on resource path and type
  def get_resource_type(type, resource_path)
    changed_path = resource_path.split('/').last
    if type.eql?('singular')
      changed_path.singularize.to_sym
    else
      changed_path.to_sym
    end
  end

  def master(resource_path)
    resource_path.split('/')[1].singularize.to_sym
  end

  def dependent(resource_path)
    resource_path.split('/').size > 3
  end

  # Just parse response to json format
  def json(response)
    JSON.parse(response.body)
  end
end
