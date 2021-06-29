require 'rails_helper'
# require_relative '../../support/devise'

RSpec.describe TasksController, type: :request do
  it_behaves_like 'A REST API',
                  resource_path: '/todos/:id/tasks',
                  comparable_attributes: %i[id content expired_at status]

end
