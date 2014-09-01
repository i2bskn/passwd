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
end

require "passwd"

RSpec.configure do |config|
  config.order = "random"
  config.after do
    Passwd::Config.instance.reset
    Passwd::Policy.instance.reset
  end
end

