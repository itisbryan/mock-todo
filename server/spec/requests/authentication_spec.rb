require 'rails_helper'
require_relative '../support/devise'

RSpec.describe 'User authentication request', type: :request do

  include RequestSpecHelper

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
      login(@current_user)
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
      login(@current_user)
      get "/todos/#{todo_id}/tasks", headers: get_auth_params_from_login_response_headers(response)
      expect(response).to have_http_status(:ok)
    end
  end

end
