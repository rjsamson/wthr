# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wthr/version'

Gem::Specification.new do |gem|
  gem.name          = "wthr"
  gem.version       = Wthr::VERSION
  gem.authors       = ["Robert J Samson"]
  gem.email         = ["rjsamson@me.com"]
  gem.description   = %q{A command line tool for interacting with the Weather Underground API}
  gem.summary       = %q{A command line tool for interacting with the Weather Underground API}
  gem.homepage      = ""

  gem.add_runtime_dependency "rb_wunderground", "~> 0.1.1"
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "rainbow"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
