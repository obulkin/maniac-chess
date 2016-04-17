FactoryGirl.define do
  factory :game do
    name "Test Game"
    white_player_id 1
    black_player_id 2
    state "open"
  end
end
