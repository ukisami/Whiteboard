# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_whiteboard_session',
  :secret      => '76a5d52db9054ac43b97efab7a085b29955ec99bc4e2421bd72a35d993c23dbbd419a0e5da6d530c22b2f5701f6317ce56b7e179bf3c85e49f90b9d2563376b4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
