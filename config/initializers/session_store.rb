# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ecommerceapp_session',
  :secret      => '3e27ea9f53eb69b0e28d1a84c25ca5d9fa35cbcf77b4a84c958541b879b89abe55930c76f8ba5c8fc64bbeb98a2afa2124536331815241a9636af4f67041273b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
