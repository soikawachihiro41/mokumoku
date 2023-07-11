# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { 'password' }
    password_confirmation { 'password' }

    trait :woman_user do
      gender { :woman }
    end

    trait :man_user do
      gender { :man }
    end
  end
end
