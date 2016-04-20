require 'rails_helper'

RSpec.describe OmniauthCallbacksController, :type => :controller do

  # Facebook authentication tests
  describe "facebook user persisted" do
    before do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '123545',
        :info => { :email => 'testuser@facebook.com' }
        })

      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
    end

    it "should successfully authenticate from Facebook" do
      user = User.find_by(email: 'testuser@facebook.com')
      expect(user.id).not_to eq(nil)
    end

    it "should successfully set flash notice" do
      expect(flash[:notice]).to eq("Successfully authenticated from Facebook account.")
    end
  end

  describe "facebook user did not persist" do
    before do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '54321',
        :info => { :email => '' }
        })

      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
    end

    it "should redirect user to new_user_registration_url" do
      expect(response).to redirect_to new_user_registration_url
    end
  end

  # Google authentication tests
  describe "google user persisted" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        :provider => 'google_oauth2',
        :uid => '678910',
        :info => { :email => 'testuser@gmail.com' }
        })

      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google_oauth2
    end

    it "should successfully authenticate from Google" do
      user = User.find_by(email: 'testuser@gmail.com')
      expect(user.id).not_to eq(nil)
    end

    it "should successfully set flash notice" do
      expect(flash[:notice]).to eq("Successfully authenticated from Google account.")
    end
  end

  describe "google user did not persist" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        :provider => 'google_oauth2',
        :uid => '019876',
        :info => { :email => '' }
        })

      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google_oauth2
    end

    it "should redirect user to new_user_registration_url" do
      expect(response).to redirect_to new_user_registration_url
    end
  end
end
