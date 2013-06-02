require "coveralls"
Coveralls.wear!

require "passwd"

RSpec.configure do |config|
  config.order = "random"
  config.before do
    @default = {
      length: 8,
      lower: true,
      upper: true,
      number: true,
      letters_lower: ('a'..'z').to_a,
      letters_upper: ('A'..'Z').to_a,
      letters_number: ('0'..'9').to_a
    }
  end
end
