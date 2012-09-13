# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mvleads_session',
  :secret      => '6f5bdc4aa20013e90d00bf43317da6b0a00a96137f30d10878e9eae74090f9054acf6af0ea39a3c261d6f8cdb017c29c42450e3f6732ee108e5776a4b16d539b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
