Passwd.current.config.tap do |config|
  # Number of hashed by stretching
  # Minimum is 4, maximum is 31, default is 12.
  # See also BCrypt::Engine
  # config.stretching = 12

  # Random generate password length
  # config.length = 10

  # Array of characters used for random password generation
  # config.characters = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
end

# Session key for authentication
# Rails.application.config.passwd.session_key = :user_id

# Authentication Model Class
# Rails.application.config.passwd.auth_class = :User

# Redirect path when not signin
# Rails.application.config.passwd.signin_path = :signin_path
