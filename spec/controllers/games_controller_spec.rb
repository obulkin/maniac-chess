require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#new action" do 
    it "should require users to be logged in" do 
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    
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

  describe "games#update action" do 
    before :each do 
      @game = FactoryGirl.create(:game, name: "Test Name", state: "open")
    end

    context "with valid attributes" do
      it "located the requested @game" do
        user = create(:user)
        sign_in user
        put :update, id: @game, game: FactoryGirl.attributes_for(:game)
        expect(@game).to eq(@game) 
    end

    it "changes @game's attributes" do 
      user = create(:user)
      sign_in user
      put :update, id: @game, 
        game: FactoryGirl.attributes_for(:game, name: "Test Name", state: "open")
        @game.reload
        expect(@game.name).to eq("Test Name")
        expect(@game.state).to eq("open")
      end

    it "redirects to the updated game" do 
      user = create(:user)
      sign_in user
      put :update, id: @game, game: FactoryGirl.attributes_for(:game)
      expect(response).to redirect_to @game
    end
  end

  context "invalid attributes" do 
    it "locates the requested @game" do 
      user = create(:user)
      sign_in user
      put :update, id: @game, game: FactoryGirl.attributes_for(:invalid_game)
      expect(@game).to eq(@game)
    end

    it "does not change @game's attributes" do 
      user = create(:user)
      sign_in user
      put :update, id: @game, 
        game: FactoryGirl.attributes_for(:game, name: "Test Game", state: nil)
        @game.reload
        expect(@game.name).not_to eq("Test Game")
        expect(@game.state).to eq("open")
      end
    end
  end

  describe "games#create action" do
    context "with valid attributes" do
      it "creates a new game" do 
        user = create(:user)
        sign_in user
        expect{
          post :create, game: attributes_for(:game)
        }.to change(Game,:count).by(1)
      end

      it "redirects to the new game" do
        user = create(:user)
        sign_in user
        post :create, game: FactoryGirl.attributes_for(:game)
        expect(response).to redirect_to Game.last
      end
    end

    context "with invalid attributes" do 
      it "does not save the new game" do
        user = create(:user)
        sign_in user
        expect{
          post :create, game: FactoryGirl.attributes_for(:invalid_game)
        }.to_not change(Game, :count)
      end

      it "re-renders the new method" do
        user = create(:user)
        sign_in user
        post :create, game: FactoryGirl.attributes_for(:invalid_game)
        expect(response).to render_template :new
      end
    end
  end
end


