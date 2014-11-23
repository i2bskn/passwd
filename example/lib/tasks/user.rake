namespace :user do
  desc "User create for development"
  task :create => :environment do
    User.find_or_create_by(email: "develop@example.com") do |u|
      u.name = "developer"
      u.salt = "fdb4bb5a745232d43874088c8edfcbaf5975d0d1e254016015991f1f3c4fc7061fd2f379b7d1f40504ddd1ff2f5feeb2caa0df895af5cb036b39f53f5ca79b04"
      # password => "secret"
      u.password = "636641d912523d7868614deed094797bfa3e9d504e0e01ab76ee2c7246555b41ff657169ac1ddbba9972fc324bc48c7fe479c0d2858105300ee203df6aeb53cc"
    end
  end
end

