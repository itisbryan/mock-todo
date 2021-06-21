# frozen_string_literal: true
FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    user { create(:user) }
    short_description { Faker::Lorem.word }
  end
end
