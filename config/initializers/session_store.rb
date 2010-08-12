# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tablevision_session',
  :secret      => '37f2f4ff71e71a4f1e0468a8db52304414ea40c8191e81f9b8de5f5c0f323f52630c2297f4c0d596b54c38156aaaef671da9c37157c9e2398ebf810d95171ff9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
