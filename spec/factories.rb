FactoryGirl.define do
  factory :user do
    # name     "Michael Hartl"
    # email    "michael@example.com"
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person-#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
    	admin true
    end
  end
  # Здесь мы сообщаем Factory Girl о том,
  # что микросообщения связаны с пользователем просто включив пользователя в определение фабрики:
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end