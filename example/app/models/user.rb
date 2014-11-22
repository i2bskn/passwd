class User < ActiveRecord::Base
  with_authenticate
end

