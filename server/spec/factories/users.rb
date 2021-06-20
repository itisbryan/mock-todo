FactoryBot.define do
	factory :user do
    username { Faker::Lorem.word }
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    sequence(:email) { |n| "test-#{n.to_s.rjust(3, '0')}@gmail.com" }
    password { 'password' }
	end
end