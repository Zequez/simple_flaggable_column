# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_flaggable_column/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_flaggable_column'
  spec.version       = SimpleFlaggableColumn::VERSION
  spec.authors       = ['Zequez']
  spec.email         = ['zequez@gmail.com']
  spec.summary       = 'Simple binary flags columns'
  spec.description   = 'This gem adds a concern to allow you to use binary flags columns in ActiveRecord models'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'with_model', '~> 1.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
