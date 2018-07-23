require "test_helper"

class PasswdTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Passwd::VERSION
  end
end
