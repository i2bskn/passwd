module Passwd
  module Base
    def random(options = {})
      c = Config.to_options.merge(options)
      Array.new(c[:length]){c[:letters][rand(c[:letters].size)]}.join
    end
  end
end

