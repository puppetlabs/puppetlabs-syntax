# frozen_string_literal: true

require 'puppetlabs-syntax'
require 'rake'
require 'rake/tasklib'

module PuppetlabsSyntax
  class RakeTask < ::Rake::TaskLib
    def filelist(paths)
      excludes = PuppetlabsSyntax.exclude_paths
      excludes.push('pkg/**/*')
      excludes.push('vendor/**/*')
      files = FileList[paths]
      files.reject! { |f| File.directory?(f) }
      files.exclude(*excludes)
    end

    def filelist_manifests
      filelist(PuppetlabsSyntax.manifests_paths)
    end

    def filelist_templates
      filelist(PuppetlabsSyntax.templates_paths)
    end

    def filelist_hiera_yaml
      filelist(PuppetlabsSyntax.hieradata_paths)
    end

    def initialize(*_args)
      desc 'Syntax check for Puppet manifests, templates and Hiera'
      task syntax: [
        'syntax:manifests',
        'syntax:templates',
        'syntax:hiera',
      ]

      namespace :syntax do
        desc 'Syntax check Puppet manifests'
        task :manifests do |t|
          warn "---> #{t.name}"

          c = PuppetlabsSyntax::Manifests.new
          output, has_errors = c.check(filelist_manifests)
          $stdout.puts "#{output.join("\n")}\n" unless output.empty?
          exit 1 if has_errors || (output.any? && PuppetlabsSyntax.fail_on_deprecation_notices)
        end

        desc 'Syntax check Puppet templates'
        task :templates do |t|
          warn "---> #{t.name}"

          c = PuppetlabsSyntax::Templates.new
          result = c.check(filelist_templates)
          unless result[:warnings].empty?
            $stdout.puts 'WARNINGS:'
            $stdout.puts result[:warnings].join("\n")
          end
          unless result[:errors].empty?
            warn 'ERRORS:'
            warn result[:errors].join("\n")
            exit 1
          end
        end

        desc 'Syntax check Hiera config files'
        task hiera: [
          'syntax:hiera:yaml',
        ]

        namespace :hiera do
          task :yaml do |t|
            warn "---> #{t.name}"
            warn "#{t.name} was called, but PuppetlabsSyntax.check_hiera_keys is false. hiera syntax won't be checked" unless PuppetlabsSyntax.check_hiera_keys
            c = PuppetlabsSyntax::Hiera.new
            errors = c.check(filelist_hiera_yaml)
            $stdout.puts "#{errors.join("\n")}\n" unless errors.empty?
            exit 1 unless errors.empty?
          end
        end
      end
    end
  end
end

PuppetlabsSyntax::RakeTask.new
