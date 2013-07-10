# -*- encoding: utf-8 -*-
require File.expand_path('../lib/port_of_call/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Trace Wax"]
  gem.email         = ["gems@tracedwax.com"]
  gem.summary       = "Import items from a CSV into an activerecord model"
  gem.homepage      = "https://github.com/tracedwax/port_of_call"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "port_of_call"
  gem.require_paths = ["lib"]
  gem.version       = PortOfCall::VERSION
  gem.license       = "MIT"

  gem.required_ruby_version = '>= 1.9.2'

  gem.add_dependency 'roo'

  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'with_model', '~> 0.3'
end
