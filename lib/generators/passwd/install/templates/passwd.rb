Passwd.current.config.tap do |config|
  # Hashing algorithm
  # Supported algorithm is :md5, :rmd160, :sha1, :sha256, :sha384 and :sha512
  # config.algorithm = :sha512

  # Number of hashed by stretching
  # Not stretching if specified nil or 0.
  # config.stretching = 100

  # Random generate password length
  # config.length = 10

  # Array of characters used for random password generation
  # config.letters = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
end

# Session key for authentication
# Rails.application.config.passwd.session_key = :user_id

# Authentication Model Class
# Rails.application.config.passwd.auth_class = :User

# Redirect path when not signin
# Rails.application.config.passwd.signin_path = :signin_path

# Salt generation logic
# Rails.application.config.passwd.random_salt = proc { SecureRandom.uuid }
