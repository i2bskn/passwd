# Passwd

[![Gem Version](https://badge.fury.io/rb/passwd.svg)](http://badge.fury.io/rb/passwd)

Passwd is provide hashed password creation and authentication.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "passwd"
```

And then execute:

```
$ bundle install
```

Create config file(Only Rails) with:

```
$ bundle exec rails generate passwd:install
```

The following file will be created.  
See [config](https://github.com/i2bskn/passwd/blob/master/lib/generators/passwd/install/templates/passwd.rb) if not Rails.

- `config/initializers/passwd.rb`

## Usage

### Ruby

```ruby
passwd = Passwd.current
passwd.random(10) # Create random password of 10 characters.
password = passwd.password_hashing("secret") # Create hashed password from plain text.
password == "secret" # => true
load_password = passwd.load_password("hashed_password") # Load hashed password.
load_password == "secret"
```

### ActiveRecord with Rails

Add authentication to your `User` model.  
Model name is `User` by default, but can be changed in configuration file.

```ruby
class User < ActiveRecord::Base
  with_authenticate
end
```

#### Options

User model The following column are required.  
Column name can be changed with the specified options.

- `:id => :email` Unique value to be used for authentication.
- `:password => :password` Column of String to save the hashed password.

Use the `name` column as id.

```ruby
class User < ActiveRecord::Base
  with_authenticate id: :name
end
```

#### Authenticate

`authenticate` method is available in both instance and class.  
Returns user object if the authentication successful.  
Returns nil if authentication fails or doesn't exists user.  
Instance method is not required `id`.

```ruby
user = User.authenticate(params[:email], params[:password]) # Returns user object or nil.
user.authenticate(params[:password]) # Returns true if authentication succeeded.
```

`set_password` method will be set random password.  
To specify password as an argument if you want to specify a password.  

```ruby
current_user.set_password("secret") # Set random password if not specified a argument.
current_user.save

new_user = User.new
random_plain_password = new_user.set_password
UserMailer.register(new_user, random_plain_password).deliver!
```

### ActionController

Already several methods is available in your controller.

If you want to authenticate the application.  
Unauthorized access is thrown exception.  
Can be specified to redirect in configuration file.

```ruby
class ApplicationController < ActionController::Base
  before_action :require_signin
end
```

If you want to implement the session management.

```ruby
class SessionsController < ApplicationController
  # If you has been enabled `require_signin` in ApplicationController
  skip_before_action :require_signin

  # GET /signin
  def new; end

  # POST /signin
  def create
    # Returns nil or user
    @user = User.authenticate(params[:email], params[:password])

    if @user
      # Save user_id to session
      signin(@user)
      redirect_to_referer_or some_path, notice: "Signin was successful. Hello #{current_user.name}"
    else # Authentication fails
      render action: :new
    end
  end

  # DELETE /signout
  def destroy
    # Clear session (Only user_id)
    signout
    redirect_to some_path
  end
end
```

`current_user` and `signin?` method available in controllers and views.

```ruby
def greet
  name = signin? ? current_user.name : "Guest"
  render text: "Hello #{name}!!"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/passwd.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
