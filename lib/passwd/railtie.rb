module Passwd
  class Railtie < ::Rails::Railtie
    config.passwd = ActiveSupport::OrderedOptions.new

    initializer "passwd" do
      require "passwd/action_controller_ext"
      require "passwd/active_record_ext"

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, Passwd::ActionControllerExt)
      end

      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:extend, Passwd::ActiveRecordExt)
      end
    end
  end
end

