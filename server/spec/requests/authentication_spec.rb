require 'rails_helper'
require_relative '../support/devise'

RSpec.describe 'User authentication request', type: :request do
  let!(:todos) { FactoryBot.create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }
  before(:each) do
    @current_user = FactoryBot.create(:user)

  end

  describe '#signed_in?' do
    let(:user) { FactoryBot.create(:user) }
    sign_in(:user)

    it 'should respond with success' do
      get '/auth/validate_token' # yes, nothing changed here
      expect(response).to have_http_status(:success)
    end
  end

  describe '#sign_up?' do
    new_user = FactoryBot.create(:user)
    it 'should respond with unprocessable entity' do
      post '/auth',
           params: { first_name: new_user.first_name, last_name: new_user.last_name,
                     username: new_user.username, email: new_user.email,
                     password: 'password', password_confirmation: 'password' }.to_json,
           headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#signed_out?' do
    it 'should respond with unauthorized' do
      get '/auth/validate_token'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'get Todos without token' do
    it 'should respond with unauthorized' do
      get '/todos'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'get Todos with token' do
    it 'should respond with ok' do
      login
      get '/todos', headers: get_auth_params_from_login_response_headers(response)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'get Tasks without token' do
    it 'should respond with unauthorized' do
      get "/todos/#{todo_id}/tasks"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'get Tasks with token' do
    it 'should respond with ok' do
      login
      get "/todos/#{todo_id}/tasks", headers: get_auth_params_from_login_response_headers(response)
      expect(response).to have_http_status(:ok)
    end
  end

  def login
    post '/auth/sign_in',
         params: { email: @current_user.email, password: 'password' }.to_json,
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

end