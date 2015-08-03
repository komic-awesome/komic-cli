# -*- encoding: utf-8 -*-

lib_dir = File.join(File.dirname(__FILE__),'lib')
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'komic/version'

Gem::Specification.new do |gem|
  gem.name          = "komic-cli"
  gem.version       = Komic::VERSION
  gem.summary       = %q{ komic-cli }
  gem.description   = %q{ komic-cli }
  gem.license       = "MIT"
  gem.authors       = ["hxgdzyuyi"]
  gem.email         = "hxgdzyuyi@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/komic-cli"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'thor'
  gem.add_dependency 'mechanize'
  gem.add_dependency 'mime-types'
  gem.add_dependency 'mini_magick'
  gem.add_dependency 'jbuilder'
  gem.add_dependency 'json-schema'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
