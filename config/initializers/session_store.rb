# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rofldubbs_session',
  :secret      => '840c87d3dfbb79b9f85a2263065518c58c83eee0037b875c0403c1e573d75543467b5ea762cd9a06fd16936ccfe62e58da01cb3da369a0aa0b7fcf295e1ccfc0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
