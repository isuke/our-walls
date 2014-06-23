FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :friend do
  end

  factory :wall do
    sequence(:name)  { |n| "Wall #{n}" }
  end

  factory :participant do
    user
    wall
    factory :owner do
      owner true
    end
  end

  factory :post do
    content "Lorem ipsum"
    participant
  end
end
