# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scottrade/version'

Gem::Specification.new do |gem|
  gem.name          = "scottrade"
  gem.version       = Scottrade::VERSION
  gem.authors       = ["Nolan Brown"]
  gem.email         = ["nolanbrown@gmail.com"]
  gem.description   = %q{Basic gem for accessing a Scottrade account}
  gem.summary       = gem.description 
  gem.homepage      = "https://github.com/nolanbrown/scottrade"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'money'
  
end
