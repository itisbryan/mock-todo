require 'rails_helper'
require_relative '../../support/devise'

RSpec.describe 'Create Task', type: :request do

  include RequestSpecHelper

  before { @current_user = FactoryBot.create(:user) }

  describe 'POST /todos/todo_id/tasks' do
    let(:todo) { create(:todo, user: @current_user) }
    let(:task) { create(:task, todo: todo) }
    let(:valid_params) do
      {
        task: {
          content: task.content.to_json,
          status: task.status.to_json
          # expired_at: task.expired_at.to_json
        }
      }
    end

    let(:invalid_nil_content) do
      {
        task: {
          content: nil
        }
      }
    end

    let(:invalid_status_params) do
      {
        task: {
          content: 'New Content 2',
          status: 'status'
        }
      }
    end

    context 'with valid parameters' do
      it 'should return correctly given params' do
        login(@current_user)
        post "/todos/#{todo.id}/tasks", params: valid_params, headers: get_auth_params_from_login_response_headers(response)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json.size).to eq(1) # includes only data
        expect(json.deep_symbolize_keys[:data].size).to eq(4) # ID, TYPE, ATTRIBUTES, RELATIONSHIPS

        expect_json_response = json.deep_symbolize_keys[:data]

        expect(expect_json_response[:id]).equal? task.id
        expect(expect_json_response[:type].to_s).to eq('task')
        expect(expect_json_response[:attributes]['content']).equal? task.content
        expect(expect_json_response[:attributes]['status']).equal? task.status
        expect(expect_json_response[:attributes]['expired_at']).equal? task.expired_at

        relationships = expect_json_response[:relationships]
        expect(relationships[:user]).equal? task.user
        expect(relationships[:todo]).equal? task.todo
      end
    end
  end

end