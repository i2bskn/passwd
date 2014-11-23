module Passwd
  class PasswdError < StandardError; end
  class UnauthorizedAccess < PasswdError; end
  class PolicyNotMatch < PasswdError; end
  class AuthenticationFails < PasswdError; end
  class ConfigError < PasswdError; end
end

