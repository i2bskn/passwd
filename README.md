# Passwd

[![Gem Version](https://badge.fury.io/rb/passwd.png)](http://badge.fury.io/rb/passwd)
[![Build Status](https://travis-ci.org/i2bskn/passwd.png?branch=master)](https://travis-ci.org/i2bskn/passwd)
[![Coverage Status](https://coveralls.io/repos/i2bskn/passwd/badge.png?branch=master)](https://coveralls.io/r/i2bskn/passwd?branch=master)
[![Code Climate](https://codeclimate.com/github/i2bskn/passwd.png)](https://codeclimate.com/github/i2bskn/passwd)

Password utilities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'passwd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install passwd

## Usage

```ruby
require 'passwd'
```

### Create random password

```ruby
password = Passwd.create
```

### Hashing password

Hashing with SHA1.

```ruby
password_hash = Passwd.hashing(password)
```

### Password settings

Default config is stored in the class instance variable.
Changing the default configs are as follows:

```ruby
Passwd.config # => Get config object.
Passwd.config(length: 10) # => Change to the default length.

Passwd.configure do |c|
  c.algorithm = :sha512
  c.length = 10
end
```

Options that can be specified:

* :algorithm => Hashing algorithm. default is :sha512.
* :length => Number of characters. default is 8.
* :lower => Skip lower case if set false. default is true.
* :upper => Skip upper case if set false. default is true.
* :number => Skip numbers if set false. default is true.
* :letters_lower => Define an array of lower case. default is ("a".."z").to_a
* :letters_upper => Define an array of upper case. default is ("A".."Z").to_a
* :letters_number => Define an array of numbers. default is ("0".."9").to_a

### Policy check

Default policy is 8 more characters and require lower case and require number.

```ruby
Passwd.policy_check("secret") # => true or false
```

### Policy settings

```ruby
Passwd.policy_configure do |c|
  c.min_length = 10
end
```

Options that can be specified:

* :min_length => Number of minimum characters. default is 8.
* :require_lower => Require lower case if set true. default is true.
* :require_upper => Require upper case if set true. default is false.
* :require_number => Require number if set true. default is true.

### Password object

Default password is randomly generated.
Default salt is "#{Time.now.to_s}".

```ruby
password = Passwd::Password.new
password.text # return text password.
password.salt_text # return text salt.
password.salt_hash # return hash salt.
password.hash # return hash password.
```

Options that can be specified:

* :password => Text password. default is random.
* :salt_text => Text salt. default is #{Time.now.to_s}.

Password authenticate:

```ruby
password = Passwd::Password.new
Passwd.auth(password.text, password.salt_hash, password.hash) # => true
Passwd.auth("invalid!!", password.salt_hash, password.hash) # => false

password == password.text # => true
password == "invalid!!" # => false
```

## For ActiveRecord

### User model

Include `Passwd::ActiveRecord` module and define id/salt/password column from `define_column` method.  
`id` column is required uniqueness.

```ruby
class User < ActiveRecord::Base
  include Passwd::ActiveRecord
  # if not specified arguments for define_column => {id: :email, salt: :salt, password: :password}
  define_column id: :id_colname, salt: :salt_colname, password: :password_colname

  ...
end
```

Available following method by defining id/salt/password column.

### Authentication

`authenticate` method is available in both instance and class.  
Return the user object if the authentication successful.  
Return the nil if authentication fails or doesn't exists user.

```ruby
user = User.authenticate(params[:email], params[:password]) # => return user object or nil.

if user
  session[:user] = user.id
  redirect_to bar_path, notice: "Hello #{user.name}!"
else
  flash.now[:alert] = "Authentication failed"
  render action: :new
end
```

instance method is not required `id`.

```ruby
current_user = User.find(session[:user])

if current_user.authenticate(params[:password]) # => return true or false
  # some process
  redirect_to bar_path, notice: "Some process is successfully"
else
  flash.now[:alert] = "Authentication failed"
  render action: :edit
end
```

### Change passowrd

`set_password` method will be set random password.  
Return value is plain text password.  
To specify the password as an argument if you want to specify a password.  
`salt` also set if salt is nil.

```ruby
current_user = User.find(session[:user])
password_text = current_user.set_password

if current_user.save
  redirect_to bar_path, notice: "Password update successfully"
else
  render action: :edit
end
```

`update_password` method will be set new password if the authentication successful.  
But `update_password` method doesn't call `save` method.

```ruby
current_user = User.find(session[:user])

begin
  Passwd.confirm_check(params[:password], params[:password_confirmation])
  # update_password(OLD_PASSWORD, NEW_PASSWORD[, POLICY_CHECK=false])
  current_user.update_password(old_pass, new_pass, true)
  current_user.save!
  redirect_to bar_path, notice: "Password updated successfully"
rescue Passwd::PasswordNotMatch
  # PASSWORD != PASSWORD_CONFIRMATION from Passwd.#confirm_check
  flash.now[:alert] = "Password not match"
  render action: :edit
rescue Passwd::AuthError
  # Authentication failed from #update_password
  flash.now[:alert] = "Password is incorrect"
  render action: :edit
rescue Passwd::PolicyNotMatch
  # Policy not match from #update_password
  flash.now[:alert] = "Policy not match"
  render action: :edit
rescue
  # Other errors
  flash.now[:alert] = "Password update failed"
  render action: :edit
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
