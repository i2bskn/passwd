# coding: utf-8

module Passwd
  class PasswdError < StandardError
  end

  class AuthError < PasswdError
  end

  class PolicyNotMatch < PasswdError
  end
end
