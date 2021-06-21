# frozen_string_literal: true
FactoryBot.define do
  factory :task do
    content { Faker::Lorem.word }
    expired_at { Date.today }
    status { ['todo', 'finished', 'in processing'].sample }
    todo { create(:todo) }
    user { create(:user) }

    trait :with_task do
      transient do
        expired_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      end
    end

  end



end
