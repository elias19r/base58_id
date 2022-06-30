# frozen_string_literal: true

require_relative 'lib/base58_id/version'

Gem::Specification.new do |s|
  s.name     = 'base58_id'
  s.version  = Base58Id::VERSION
  s.license  = 'MIT'
  s.summary  = 'Convert an Integer ID or a UUID String to/from Base58 String'
  s.homepage = 'https://github.com/elias19r/base58_id'
  s.author   = 'Elias Rodrigues'

  s.files = Dir[
    'lib/**/*',
    'spec/**/*',
    '.gitignore',
    '.rubocop.yml',
    'Gemfile',
    'LICENSE',
    'README.md',
    'base58_id.gemspec'
  ]

  s.required_ruby_version = '>= 2.7'
  s.metadata = {
    'source_code_uri'       => "https://github.com/elias19r/base58_id/tree/v#{Base58Id::VERSION}",
    'rubygems_mfa_required' => 'true'
  }

  s.add_development_dependency 'bundler', '~> 2.1'
  s.add_development_dependency 'pry-byebug', '~> 3.9'
  s.add_development_dependency 'rspec', '~> 3.11'
  s.add_development_dependency 'rubocop', '~> 1.31'
  s.add_development_dependency 'rubocop-performance', '~> 1.14'
  s.add_development_dependency 'rubocop-rspec', '~> 2.11'
  s.add_development_dependency 'simplecov', '~> 0.21.0'
end
