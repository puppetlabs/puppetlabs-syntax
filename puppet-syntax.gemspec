# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-syntax/version'

Gem::Specification.new do |spec|
  spec.name          = 'puppet-syntax'
  spec.version       = PuppetSyntax::VERSION
  spec.email         = ['modules-team@puppet.com']
  spec.authors       = ['Puppet, Inc.']
  spec.summary       = 'Syntax checks for Puppet manifests, templates, and Hiera YAML'
  spec.homepage      = 'https://github.com/puppetlabs/puppetlabs-syntax/'
  spec.license       = 'MIT'
  spec.description   = <<-DESC
    Syntax checks for Puppet manifests and templates.
  DESC
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'puppet', '>= 8', '< 10'
  spec.add_dependency 'rake', '~> 13.1'

  spec.add_development_dependency 'voxpupuli-rubocop', '~> 5.2.0'
end
