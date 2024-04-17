# frozen_string_literal: true

$LOAD_PATH.push('lib')
require 'vero/version'

Gem::Specification.new do |spec|
  spec.name     = 'vero'
  spec.version  = Vero::VERSION.dup
  spec.authors  = ['James Lamont']
  spec.email    = ['support@getvero.com']

  spec.summary  = 'Ruby gem for Vero'
  spec.description = 'Ruby gem for Vero'
  spec.homepage = 'http://www.getvero.com/'

  spec.files         = Dir['**/*']
  spec.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.6'

  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'rest-client'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
