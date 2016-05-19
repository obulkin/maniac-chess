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

    factory :knight, class: "Knight" do
      type "Knight"
    end

    factory :bishop, class: "Bishop" do
      type "Bishop"
    end
  end
end
