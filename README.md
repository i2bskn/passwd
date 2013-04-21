# Passwd

Password utility

## Installation

Add this line to your application's Gemfile:

    gem 'passwd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install passwd

## Usage

    require 'passwd'

Create random password:

    password = Passwd.create

Options that can be specified:

* :length => Number of characters. default is 8.
* :lower => Skip lower case if set false. default is true.
* :upper => Skip upper case if set false. default is true.
* :number => Skip numbers if set false. default is true.
* :letters_lower => Define an array of lower case. default is ("a".."z").to_a
* :letters_upper => Define an array of upper case. default is ("A".."Z").to_a
* :letters_number => Define an array of numbers. default is ("0".."9").to_a

Password hashing:

    password_hash = Passwd.hashing(password)

Password policy check:

    Passwd.policy_check(password)

Options that can be specified:

* :min_length => Minimum length of password. default is 8.
* :min_type => Minimum types of password. default is 2.(types is lower/upper/number)
* :specify_type => Check of each types. default is false.
* :require_lower => Require lower case if set true. specify_type enabled when true.
* :require_upper => Require upper case if set true. specify_type enabled when true.
* :require_number => Require number case if set true. specify_type enabled when true.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request