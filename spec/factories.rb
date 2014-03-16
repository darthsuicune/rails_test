FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:surname) { |n| "Surname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "password"
    password_confirmation "password"
    
    factory :admin do
      admin true
    end
  end
end