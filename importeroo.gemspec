# -*- encoding: utf-8 -*-
require File.expand_path('../lib/importeroo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Trace Wax", "Eric Hu"]
  gem.email         = ["gems@tracedwax.com"]
  gem.summary       = "Import items from a CSV into an activerecord model"
  gem.homepage      = "https://github.com/tracedwax/importeroo"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "importeroo"
  gem.require_paths = ["lib"]
  gem.version       = Importeroo::VERSION
  gem.license       = "MIT"

  gem.required_ruby_version = '>= 1.9.2'

  gem.add_dependency 'roo'
  gem.add_dependency 'google-spreadsheet-ruby'

  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'with_model', '~> 0.3'
end
