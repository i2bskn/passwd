class Passwd
  class Railtie < ::Rails::Railtie
    config.passwd = ActiveSupport::OrderedOptions.new

    initializer "passwd" do
      require "passwd/rails/action_controller_ext"
      require "passwd/rails/active_record_ext"

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.include ::Passwd::Rails::ActionControllerExt
      end

      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.extend Passwd::Rails::ActiveRecordExt
      end
    end
  end
end
