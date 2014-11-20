module Passwd
  module ActionControllerExt
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
    end

    def current_user
      @current_user ||= auth_class.find_by(id: session[auth_key])
    end

    def signin!(user)
      @current_user = user
      session[auth_key] = user.id
    end

    def signout!
      @current_user = session[auth_key] = nil
    end

    private
      def auth_key
        Rails.application.config.passwd.session_key
      end

      def auth_class
        @_auth_class ||=
          Rails.application.config.passwd.authenticate_class.to_s.constantize
      end

      def _redirect_path
        _to = Rails.application.config.passwd.redirect_to
        _to ? Rails.application.routes.url_helpers.send(_to) : nil
      end

      def require_signin
        unless current_user
          if _redirect_path
            redirect_to _redirect_path
          else
            raise
          end
        end
      end
  end
end

