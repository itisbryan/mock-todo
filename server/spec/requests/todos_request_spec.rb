require 'rails_helper'
# require_relative '../../support/devise'

RSpec.describe TodosController, type: :request do
  it_behaves_like 'A REST API',
                  resource_path: '/todos',
                  comparable_attributes: %i[id title short_description]
end
