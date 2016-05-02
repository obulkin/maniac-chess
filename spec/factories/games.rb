FactoryGirl.define do
  factory :game do
    name "Test Game"
    association :white_player, factory: :user
    association :black_player, factory: :user
    state "open"
  end
  
  factory :invalid_game, parent: :game do 
    name nil
  end
end
