namespace :user do
  # E.G. rake name="Taro Suzuki" email=taro@example.com password=secret user:create
  desc "create user (specify env of name and email and password)"
  task :create => :environment do
    raise ArgumentError, "email is required" if ENV["email"].nil?
    raise ArgumentError, "name is required" if ENV["name"].nil?

    raise "must be a unique email" if User.exists?(email: ENV["email"])
    
    user = User.new(name: ENV["name"], email: ENV["email"])

    password = user.set_password(ENV["password"])
    user.save!
    puts "Creating a user was successful.\nPassword: #{password}"
  end

  # E.G. rake email=taro@example.com password=secret user:password_update
  desc "update password (specify env of email and password)"
  task :password_update => :environment do
    raise ArgumentError, "email is required" if ENV["email"].nil?
    raise "must specify the email that exists" unless User.exists?(email: ENV["email"])

    user = User.find_by(email: ENV["email"])
    password = user.set_password(ENV["password"])
    user.save!
    puts "Password update was successful.\nPassword: #{password}"
  end
end
