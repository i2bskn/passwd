require "singleton"
require "digest/sha1"
require "digest/sha2"

require "passwd/version"
require "passwd/errors"
require "passwd/base"
require "passwd/password"
require "passwd/active_record"

module Passwd
  extend Base
end

