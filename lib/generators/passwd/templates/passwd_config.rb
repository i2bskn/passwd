Passwd.configure do |c|
  # Password settings
  # The following settings are all default values.

  # Hashing algorithm
  # Supported algorithm is :md5, :rmd160, :sha1, :sha256, :sha384 and :sha512
  # c.algorithm = :sha512

  # Random generate password length
  # c.length = 8

  # Number of hashed by stretching
  # Not stretching if specified nil.
  # c.stretching = nil

  # Character type that is used for password
  # c.lower = true
  # c.upper = true
  # c.number = true
end

Passwd.policy_configure do |c|
  # Minimum password length
  # c.min_length = 8

  # Character types to force the use
  # c.require_lower = true
  # c.require_upper = false
  # c.require_number = true
end

# Session key for authentication
Rails.application.config.passwd.session_key = :user_id

# Authentication Model Class
Rails.application.config.passwd.authenticate_class = :User

# Redirect path when not signin
# E.G. :signin_path # Do not specify ***_url
Rails.application.config.passwd.redirect_to = nil

