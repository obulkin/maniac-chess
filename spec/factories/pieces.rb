FactoryGirl.define do
  factory :piece do
    type "King"
    color "white"
    rank 1
    file 1
    association :game
  end

  factory :king do
    type "King"
    color "white"
    rank 1
    file 5
    association :game
  end
end
