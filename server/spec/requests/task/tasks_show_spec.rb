require 'rails_helper'
require_relative '../../support/devise'

RSpec.describe 'Show Task', type: :request do

  include RequestSpecHelper

  before do
    @current_user = FactoryBot.create(:user)
  end

  describe 'GET /todos/todo_id/tasks' do
    let(:todo) { FactoryBot.create(:todo, user: @current_user) }
    let(:tasks) { FactoryBot.create_list(:task, 10, todo: todo) }
    it 'should return all tasks belong to specified todo' do
      login(@current_user)
      get "/todos/#{todo.id}/tasks", headers: get_auth_params_from_login_response_headers(response)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.size).to eq 2
      expect(json.deep_symbolize_keys[:data].size).to eq(todo.tasks.size)
    end
  end

end
