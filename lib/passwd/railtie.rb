class Passwd
  class Railtie < ::Rails::Railtie
    config.passwd = ActiveSupport::OrderedOptions.new

    initializer "passwd" do
      require "passwd/rails/action_controller_ext"

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, ::Passwd::Rails::ActionControllerExt)
      end
    end
  end
end
