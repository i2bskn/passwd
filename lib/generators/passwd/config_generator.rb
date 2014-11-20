module Passwd
  module Generators
    class ConfigGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc "Create Passwd configuration file"
      def create_configuration_file
        template "passwd_config.rb", "config/initializers/passwd.rb"
      end
    end
  end
end

