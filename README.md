# Passwd

[![Gem Version](https://badge.fury.io/rb/passwd.svg)](http://badge.fury.io/rb/passwd)

Password utilities and integration to Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "passwd"
```

And then execute:

    $ bundle

## Usage

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
- `:salt => :salt` Column of String to save the salt.
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
user = User.authenticate(params[:email], params[:password]) # => return user object or nil.
user.authenticate(params[:password])
```

`set_password` method will be set random password.  
To specify password as an argument if you want to specify a password.  

```ruby
current_user.set_password("secret") # => random password if not specified a argument.
current_user.passwd.plain # => new password
current_user.save

new_user = User.new
password = new_user.passwd.plain
UserMailer.register(new_user, password).deliver!
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
      redirect_to some_path, notice: "Signin was successful. Hello #{current_user.name}"
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

`current_user` method available if already signin.

```ruby
# app/controllers/greet_controller.rb
def greet
  render text: "Hello #{current_user.name}!!"
end

# app/views/greet/greet.html.erb
<p>Hello <%= current_user.name %>!!<p>
```

### Generate configuration file

Run generator of Rails.  
Configuration file created to `config/initializers/passwd.rb`.

```
$ bundle exec rails generate passwd:install
```

## Contributing

1. Fork it ( https://github.com/i2bskn/passwd/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
