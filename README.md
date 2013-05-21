# Passwd

[![Build Status](https://travis-ci.org/i2bskn/passwd.png?branch=master)](https://travis-ci.org/i2bskn/passwd)

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

Default config is stored in the class variable. (@@config)
Changing the default configs are as follows:

```ruby
Passwd.config => Get config hash.
Passwd.config(length: 10) => Change to the default length.
```

Options that can be specified:

* :length => Number of characters. default is 8.
* :lower => Skip lower case if set false. default is true.
* :upper => Skip upper case if set false. default is true.
* :number => Skip numbers if set false. default is true.
* :letters_lower => Define an array of lower case. default is ("a".."z").to_a
* :letters_upper => Define an array of upper case. default is ("A".."Z").to_a
* :letters_number => Define an array of numbers. default is ("0".."9").to_a

### Password policy check

```ruby
Passwd.policy_check(password)
```

### Policy settings

Default policy is stored in the class variable. (@@policy)
Changing the default policy are as follows:

```ruby
Passwd.policy => Get policy hash.
Passwd.policy(min_length: 10) => Change to the default min_length.
```

Options that can be specified:

* :min_length => Minimum length of password. default is 8.
* :min_type => Minimum types of password. default is 2.(types is lower/upper/number)
* :specify_type => Check of each types. default is false.
* :require_lower => Require lower case if set true. specify_type enabled when true.
* :require_upper => Require upper case if set true. specify_type enabled when true.
* :require_number => Require number case if set true. specify_type enabled when true.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
