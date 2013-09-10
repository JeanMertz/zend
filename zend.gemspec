# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zend/version'

Gem::Specification.new do |spec|
  spec.name          = 'zend'
  spec.version       = Zend::VERSION
  spec.authors       = ['Jean Mertz']
  spec.email         = ['jean@mertz.fm']
  spec.description   = %q{Interact with Zendesk through your terminal.}
  spec.summary       = %q{A command line interface to everything Zendesk}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'zendesk_api', '~> 1.0.3'
  spec.add_dependency 'thor'
  spec.add_dependency 'highline'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'netrc'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
