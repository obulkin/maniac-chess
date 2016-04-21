FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "dummy-email#{n}@domain.com"}
    password "fake_pass"
  end
end
