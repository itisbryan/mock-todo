# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    username { SecureRandom.hex(4) }
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    sequence(:email) { |n| "test-#{n.to_s.rjust(3, '0')}@gmail.com" }
    password { 'password' }
    is_public { true }
  end

  trait :private do
    is_public { false }
  end
end
