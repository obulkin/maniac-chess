FactoryGirl.define do
  factory :piece do
    type "King"
    color "white"
    rank 1
    file 1
    association :game

    factory :pawn, class: "Pawn" do
      type "Pawn"
    end
  end
end
