require 'rails_helper'
require_relative '../support/devise'

RSpec.describe 'Todo Controller', type: :controller do
  describe 'GET /todos' do
    before do
      sign_in user
      get :todo_path
    end

    context 'it should returns a list of todos that belongs to current user' do
      it 'should have the status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
