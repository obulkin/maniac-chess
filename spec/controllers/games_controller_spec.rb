require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#new action" do 
    it "should return success response on the get request" do
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

    it "should return a 404 error if the game is not found" do 
      get :show, id: 'GAMETESTERROR'
      expect(response).to have_http_status(:not_found)
    end
  end
end
