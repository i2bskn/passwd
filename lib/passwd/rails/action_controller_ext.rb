module Passwd::Rails
  module ActionControllerExt
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signin?
    end

    private

      def current_user
        return @current_user if instance_variable_defined?(:@current_user)

        @current_user = _auth_class.find_by(id: session[_auth_key])
      end

      def signin?
        current_user.present?
      end

      def signin(user)
        if user.present?
          @current_user = user
          session[_auth_key] = user&.id
        end

        user.present?
      end

      def signout
        session[_auth_key] = nil
        @current_user = nil
      end

      def redirect_to_referer_or(path)
        redirect_to session[:referer].presence || path
      end

      def require_signin
        unless signin?
          path = _signin_path
          raise UnauthorizedAccess unless path
          session[:referer] = request.fullpath
          redirect_to path
        end
      end

      def passwd_auth_class
        nil
      end

      def passwd_auth_key
        nil
      end

      def passwd_signin_path
        nil
      end

      def _auth_class
        (Rails.application.config.passwd.auth_class || passwd_auth_class || :User).to_s.constantize
      end

      def _auth_key
        Rails.application.config.passwd.session_key || passwd_auth_key || :user_id
      end

      def _signin_path
        name = Rails.application.config.passwd.signin_path || passwd_signin_path || :signin_path
        _url_helpers.respond_to?(name) ? _url_helpers.public_send(name) : nil
      end

      def _url_helpers
        Rails.application.routes.url_helpers
      end
  end
end
