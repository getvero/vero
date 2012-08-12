
# -*- encoding: utf-8 -*-
$:.push('lib')
require "vero/version"

Gem::Specification.new do |s|
  s.name     = "vero"
  s.version  = Vero::VERSION.dup
  s.date     = Time.now.strftime("%Y-%m-%d")
  s.summary  = "Rails 3.x gem for Vero"
  s.email    = "support@getvero.com"
  s.homepage = "http://www.getvero.com/"
  s.authors  = ['James Lamont']
  
  dependencies = [
    [:development, 'rails'],
    [:development, 'debugger'],
    [:development, 'rspec'],
    [:runtime, 'rest-client'],
    [:runtime, 'delayed_job'],
    [:runtime, 'delayed_job_active_record'],
    [:runtime, 'delayed_job_mongoid']
  ]
  
  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "1.8.23"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
  
  dependencies.each do |type, name, version|
    if s.respond_to?("add_#{type}_dependency")
      s.send("add_#{type}_dependency", name, version)
    else
      s.add_dependency(name, version)
    end
  end
end
