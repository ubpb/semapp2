# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_semapp2-trunk_session',
  :secret      => '29948e4a0ef28b74206222ddca3238b5ca88891f79d24566a460a7c257e90062f0cb7ff959beae299fd45ba9de5b1808d4ad71e3fa0f7ffccf2f7077ed400b80'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
