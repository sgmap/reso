# frozen_string_literal: true

FactoryGirl.define do
  factory :visit do
    association :advisor, factory: :user
    association :company
    happened_at 3.days.from_now

    trait :with_facility do
      association :facility
    end
  end
end
