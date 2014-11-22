require "simplecov"
require "coveralls"
Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter "spec"
  add_filter ".bundle"
  add_filter "example"
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../example/config/environment", __FILE__)
require "passwd"

RSpec.configure do |config|
  config.order = "random"
end

