# frozen_string_literal: true
FactoryBot.define do
  factory :task do
    content { Faker::Lorem.word }
    expired_at { Faker::Lorem.day }
    status { %w[todo finished].sample }
    todo { create(:todo) }
    user { create(:user) }
  end
end
