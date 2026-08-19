# frozen_string_literal: true

source 'https://rubygems.org'

# Find a location or specific version for a gem. place_or_version can be a
# version, which is most often used. It can also be git, which is specified as
# `git://somewhere.git#branch`. You can also use a file source location, which
# is specified as `file://some/location/on/disk`.
def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ /^(https[:@][^#]*)#(.*)/
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  elsif place_or_version =~ %r{^file://(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

# Specify your gem's dependencies in puppet-syntax.gemspec
gemspec

# Override gemspec for CI matrix builds.
# But only if the environment variable is set
gem 'puppet', *location_for(ENV['PUPPET_VERSION']) if ENV['PUPPET_VERSION']
# Puppet on Ruby 3.3 / 3.4 has some missing dependencies
gem 'syslog', '~> 0.3' if RUBY_VERSION >= '3.4'

# Windows platform runtime deps. The published puppet/openvox rubygems.org
# artefacts are built on Linux and guard `ffi` / `win32ole` with build-host
# platform checks, so those deps never make it into the Linux-published
# artefact. Ruby 3.4+ removed win32ole from default gems, making the missing
# declaration fatal at require-time on Windows. Declaring them here in the
# Gemfile is evaluated on the install host at bundle time, so bundler pulls
# them on Windows only.
platforms :mingw, :x64_mingw, :mswin do
  gem 'ffi', '>= 1.15.5', '< 1.17.0', '!= 1.16.0', '!= 1.16.1', '!= 1.16.2'
  gem 'win32ole', '>= 1.8', '< 2.0'
end

group :test do
  gem 'rspec'
end

group :release, optional: true do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.18.0', require: false
end
