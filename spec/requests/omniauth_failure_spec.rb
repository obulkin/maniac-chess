require 'rails_helper'

RSpec.describe "GET '/auth/failure'", :type => :request do

  it "should redirect user to root path if authentication failed" do
    get "/users/auth/failure"
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Could not authenticate.")
  end
end
