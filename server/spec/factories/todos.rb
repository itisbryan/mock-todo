FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    user { create(:user) }
  end
end