# frozen_string_literal: true

$LOAD_PATH.push('lib')
require 'vero/version'

Gem::Specification.new do |s|
  s.name     = 'vero'
  s.version  = Vero::VERSION.dup
  s.date     = Time.now.strftime('%Y-%m-%d')
  s.summary  = 'Ruby gem for Vero'
  s.email    = 'support@getvero.com'
  s.homepage = 'http://www.getvero.com/'
  s.authors  = ['James Lamont']

  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'rest-client'

  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ['lib']

  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = '1.8.23'
  s.required_ruby_version = '>= 2.4.0'
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
end
