# require_relative './controller_macros'

RSpec.configure do |config|
  # For Devise > 4.1.1
  #config.include Devise::Test::ControllerHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :request
  #config.extend ControllerMacros, type: :request
end
