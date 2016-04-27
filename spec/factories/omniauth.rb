FactoryGirl.define do

  factory :auth_hash, class: OmniAuth::AuthHash do
    skip_create

    transient do
      sequence(:uid)
      provider "provider"
      email { "email" }
    end

    initialize_with do
      OmniAuth::AuthHash.new({
        provider: provider,
        uid: uid,
        info: {
          email: email
        }
      })
    end

    trait :facebook do
      provider "facebook"
      email "testuser@facebook.com"
    end

    trait :google_oauth2 do
      provider "google_oauth2"
      email "testuser@gmail.com"
    end

    trait :does_not_persist do
      email ""
    end
    
  end
end
