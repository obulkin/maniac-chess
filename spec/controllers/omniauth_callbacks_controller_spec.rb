require 'rails_helper'

RSpec.describe OmniauthCallbacksController, :type => :controller do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#facebook" do
    it "should successfully authenticate using Facebook authentication hash and display a success message in flash, if the user persists" do
      request.env["omniauth.auth"] = FactoryGirl.create(:auth_hash, :facebook)
      get :facebook
      user = User.find_by(email: 'testuser@facebook.com')
      expect(user).not_to eq(nil)
      expect(flash[:notice]).to eq("Successfully authenticated from Facebook account.")
      expect(subject.current_user).to eq(user)
    end

    it "should redirect the user to the new user registration form, if the user does not persist" do
      request.env["omniauth.auth"] = FactoryGirl.create(:auth_hash, :facebook, :does_not_persist)
      get :facebook
      expect(flash[:notice]).to eq("We were not able to authenticate you. Try signing up directly with MANIAC chess by entering an email address and creating a new password.")
      expect(response).to redirect_to new_user_registration_url
    end
  end

  describe "#google" do
    it "should successfully authenticate using Google authentication hash and display a success message in flash, if the user persists" do
      request.env["omniauth.auth"] = FactoryGirl.create(:auth_hash, :google)
      get :google
      user = User.find_by(email: 'testuser@gmail.com')
      expect(user).not_to eq(nil)
      expect(flash[:notice]).to eq("Successfully authenticated from Google account.")
      expect(subject.current_user).to eq(user)
    end

    it "should redirect the user to the new user registration form, if the user does not persist" do
      request.env["omniauth.auth"] = FactoryGirl.create(:auth_hash, :google, :does_not_persist)
      get :google
      expect(flash[:notice]).to eq("We were not able to authenticate you. Try signing up directly with MANIAC chess by entering an email address and creating a new password.")
      expect(response).to redirect_to new_user_registration_url
    end
  end

  describe "#failure" do
    it "should redirect to the homepage and add an error message to the flash" do
      Rails.application.routes.draw do
        devise_scope :user do
          get '/users/auth/failure' => 'omniauth_callbacks#failure'
        end
        root 'static_pages#index'
      end

      get :failure
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq("Uh oh, looks like something went wrong! Please try again later or sign up with MANIAC Chess directly by providing an email address and password.")

      Rails.application.reload_routes!
    end
  end
end
