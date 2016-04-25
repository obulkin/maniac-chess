require 'rails_helper'

RSpec.describe OmniauthCallbacksController, :type => :controller do

  describe "#facebook callback" do

    context "given user did persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '123545',
          :info => { :email => 'testuser@facebook.com' }
          })

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
        get :facebook
      end

      it "should successfully authenticate from user's Facebook account" do
        user = User.find_by(email: 'testuser@facebook.com')
        expect(user.id).not_to eq(nil)
        expect(flash[:notice]).to eq("Successfully authenticated from Facebook account.")
        # expect(response).to redirect_to root_path
      end
    end

    context "given user did not persist" do
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
  end


  describe "#google_oauth2 callback" do

    context "given user did persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = OmniAuth::AuthHash.new({
          :provider => 'google_oauth2',
          :uid => '678910',
          :info => { :email => 'testuser@gmail.com' }
          })

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
        get :google_oauth2
      end

      it "should successfully authenticate from user's Google account and set flash notice" do
        user = User.find_by(email: 'testuser@gmail.com')
        expect(user.id).not_to eq(nil)
        expect(flash[:notice]).to eq("Successfully authenticated from Google account.")
      end
    end

    context "given user did not persist" do
      before do
        OmniAuth.config.mock_auth[:do_omniauth] = OmniAuth::AuthHash.new({
          :provider => 'google_oauth2',
          :uid => '019876',
          :info => { :email => '' }
          })

        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:do_omniauth]
        get :google_oauth2
      end

      it "should redirect user to new_user_registration_url" do
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

  # describe "#failure" do
  #   before do
  #     OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  #     OmniAuth.config.on_failure = Proc.new { |env|
  #       OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  #     }
  #
  #     request.env["devise.mapping"] = Devise.mappings[:user]
  #     request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  #     get :facebook
  #   end
  #
  #   it "should redirect user to root path if authentication failed" do
  #     expect(response).to redirect_to root_path
  #   end
  # end
end
