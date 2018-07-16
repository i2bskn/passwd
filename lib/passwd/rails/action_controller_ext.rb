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
        @current_user = session[_auth_key] = nil
      end

      def require_signin
        unless current_user
          path = after_signout_redirect_path(nil)
          raise ActionController::RoutingError unless path
          session[:referer] = request.fullpath
          redirect_to path
        end
      end

      def redirect_to_referer_or(path)
        redirect_to session[:referer].presence || path
      end

      def redirect_path_when_unsigned(object)
        nil
      end

      def _auth_class
        (Rails.application.config.passwd.auth_class || :User).to_s.constantize
      end

      def _auth_key
        Rails.application.config.passwd.session_key || :user_id
      end
  end
end
