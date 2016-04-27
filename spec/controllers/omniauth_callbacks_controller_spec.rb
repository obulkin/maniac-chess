require 'rails_helper'

RSpec.describe OmniauthCallbacksController, :type => :controller do

  describe "#facebook" do

    context "given user does persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = FactoryGirl.create(:auth_hash, :facebook)

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
      end

      it "should successfully authenticate using Facebook authentication hash and display a success message in flash" do
        get :facebook
        user = User.find_by(email: 'testuser@facebook.com')
        expect(user.id).not_to eq(nil)
        expect(flash[:notice]).to eq("Successfully authenticated from Facebook account.")
      end
    end

    context "given user does not persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = FactoryGirl.create(:auth_hash, :facebook, :does_not_persist)

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
      end

      it "should redirect the user to the new user registration form" do
        get :facebook
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end


  describe "#google_oauth2" do

    context "given user does persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = FactoryGirl.create(:auth_hash, :google_oauth2)

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
      end

      it "should successfully authenticate using Google authentication hash and display a success message in flash" do
        get :google_oauth2
        user = User.find_by(email: 'testuser@gmail.com')
        expect(user.id).not_to eq(nil)
        expect(flash[:notice]).to eq("Successfully authenticated from Google account.")
      end
    end

    context "given user does not persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = FactoryGirl.create(:auth_hash, :google_oauth2, :does_not_persist)

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
      end

      it "should redirect the user to the new user registration form" do
        get :google_oauth2
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

  describe "#failure" do
    it "should redirect to the homepage and add an error message to the flash" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :failure
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq("Could not authenticate.")
    end
  end
end
