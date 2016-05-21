# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
MANIACChess::Application.config.secret_key_base = if Rails.env.development? or Rails.env.test?
  'f4e0e54e5ad27a1e9a73f9be70801966b90880e25bd75cce40483789d439deeec6d1224d24fdc208d907640f5dddd6013cff2c62204250dbb8480fdcda375def'
else
  ENV['SECRET_TOKEN']
end
