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
  c.length = 10
end
```

Options that can be specified:

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
user = User.authenticate("foo@example.com", "secret") # => return user object or nil.

if user
  puts "Hello #{user.name}!"
else
  puts "Authentication failed"
end
```

instance method is not required `id`.

```ruby
user = User.find(params[:id])
if user.authenticate("secret") # => return true or false
  puts "Authentication is successful!"
else
  puts "Authentication failed!"
end
```

### Change passowrd

`set_password` method will be set random password.  
Return value is plain text password.  
To specify the password as an argument if you want to specify a password.  
`salt` also set if salt is nil.

```ruby
user = User.find(params[:id])
password_text = user.set_password

if user.save
  NoticeMailer.change_mail(user, password_text).deliver
end
```
`update_password` method will be set new password if the authentication successful.  
Return the nil if authentication fails.  
But `update_password` method doesn't call `save` method.

```ruby
user.find(params[:id])
if user.update_password(old_pass, new_pass) # => return new password(text) or false
  if user.save
    NoticeMailer.change_mail(user, password_text).deliver
  end
else
  puts "Authentication failed!"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
