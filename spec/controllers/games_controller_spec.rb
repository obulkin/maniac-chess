require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#new action" do 
    it "should return success response on the get request" do
      user = create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#show action" do 
    it "should return success response on the get request" do
      game = create(:game)
      get :show, id: game.id
      expect(response).to have_http_status(:success)
    end

    it "should return a Game Not Found error if the game is not found" do 
      get :show, id: '99999999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "games#create action" do
    it "should successfully create a new game in the database" do
      user = create(:user)
      sign_in user
      post :create, game: {name: 'User1'}
      expect(response).to redirect_to game_path(@game, @name)

      game = Game.last 
      expect(game.message).to eq(" ")
    end

    it "should properly deal with validation errors" do
      user = create(:user)
      sign_in user
      post :create, game: {name: 'User1'}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Game.count).to eq 0
    end
  end
end
