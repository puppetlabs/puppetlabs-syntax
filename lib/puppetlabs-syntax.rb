# frozen_string_literal: true

require 'puppetlabs-syntax/version'

module PuppetlabsSyntax
  autoload :Hiera, 'puppetlabs-syntax/hiera'
  autoload :Manifests, 'puppetlabs-syntax/manifests'
  autoload :Templates, 'puppetlabs-syntax/templates'

  @exclude_paths = [
    'spec/fixtures/**/*',
    'pkg/**/*',
    'vendor/**/*',
    '.vendor/**/*',
  ]
  @hieradata_paths = [
    '**/data/**/*.*{yaml,yml}',
    'hieradata/**/*.*{yaml,yml}',
    'hiera*.*{yaml,yml}',
  ]
  @manifests_paths = [
    '**/*.pp',
  ]
  @templates_paths = [
    '**/templates/**/*.erb',
    '**/templates/**/*.epp',
  ]
  @fail_on_deprecation_notices = true
  @check_hiera_keys = true
  @check_hiera_data = true

  class << self
    attr_accessor :exclude_paths,
                  :hieradata_paths,
                  :manifests_paths,
                  :templates_paths,
                  :fail_on_deprecation_notices,
                  :epp_only,
                  :check_hiera_keys,
                  :check_hiera_data
  end
end
