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

  gem.add_runtime_dependency 'thor', '~> 0.19'
  gem.add_runtime_dependency 'mechanize', '~> 2.7'
  gem.add_runtime_dependency 'mime-types', '~> 2.6'
  gem.add_runtime_dependency 'mini_magick', '~> 4.2'
  gem.add_runtime_dependency 'jbuilder', '~> 2.3'
  gem.add_runtime_dependency 'json-schema', '~> 2.5'
  gem.add_runtime_dependency 'ruby-progressbar', '~> 1.7'
  gem.add_runtime_dependency 'rubyzip', '~> 1.1'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
