# frozen_string_literal: true

require_relative 'lib/base58_id/version'

Gem::Specification.new do |s|
  s.name     = 'base58_id'
  s.version  = Base58Id::VERSION
  s.license  = 'MIT'
  s.summary  = 'Convert Integer ID or UUID String to/from Base58 String; Generate random Base58 String'
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

  s.required_ruby_version = '>= 3.1.4'
  s.metadata = {
    'source_code_uri'       => "https://github.com/elias19r/base58_id/tree/v#{Base58Id::VERSION}",
    'rubygems_mfa_required' => 'true'
  }
end
