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

  describe "games#create action" do
    context "with valid attributes" do
      it "creates a new game using the data provided to the controller" do 
        user = create :user
        sign_in user
        expect{post :create, game: {name: "Valid Game"}}.to change(Game, :count).by(1)
        expect(Game.find_by(name: "Valid Game")).to_not eq(nil)
      end

      it "redirects to the new game" do
        user = create(:user)
        sign_in user
        post :create, game: {name: "Valid Game 2"}
        expect(response).to redirect_to(game_path(Game.find_by(name: "Valid Game 2")))
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

  describe "#update" do
    let(:game) {create :game}

    describe "without a logged-in user" do
      it "should redirect to the user sign in page" do
        put :update, id: game.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "with a logged-in user" do
      let(:user) {create :user}
      before(:each) {sign_in user}

      it "should throw an Active Record exception if the ID provided is malformed or doesn't match any existing games" do
        last_game = Game.last
        unused_id = last_game ? last_game.id + 1 : 1
        expect{put :update, id: "malformed"}.to raise_exception(ActiveRecord::RecordNotFound)  
        expect{put :update, id: unused_id}.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it "should make the logged-in user the game's black player and redirect properly if the ID is valid" do
        put :update, id: game.id
        game.reload
        expect(game.black_player.id).to eq(user.id)
        expect(response).to redirect_to(game_path game)
      end
    end
  end
end


