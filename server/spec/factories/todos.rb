# frozen_string_literal: true
FactoryBot.define do
  factory :todo do
    title { SecureRandom.hex(10) }
    user { create(:user) }
    short_description { Faker::Lorem.word }
  end
end
