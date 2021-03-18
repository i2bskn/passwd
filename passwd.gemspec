lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "passwd/version"

Gem::Specification.new do |spec|
  spec.name          = "passwd"
  spec.version       = Passwd::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["iiboshi@craftake.co.jp"]

  spec.description   = %q{Passwd is provide hashed password creation and authentication.}
  spec.summary       = %q{Passwd is provide hashed password creation and authentication.}
  spec.homepage      = "https://github.com/i2bskn/passwd"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bcrypt", "~> 3.1.0"
  spec.add_development_dependency "bundler", ">= 2.1.0"
  spec.add_development_dependency "rake", "~> 13.0.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "rubocop", "1.11.0"
  spec.add_development_dependency "pry", "~> 0.14.0"
end
