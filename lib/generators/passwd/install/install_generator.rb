module Passwd::Generators
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Create Passwd config file"
    def create_config_file
      copy_file "passwd.rb", "config/initializers/passwd.rb"
    end
  end
end
