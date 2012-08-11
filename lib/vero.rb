require 'rails'

module Vero 
  autoload :Config,     'vero/config'
  autoload :Logger,     'vero/logger'
  autoload :App,        'vero/app'
  autoload :Context,    'vero/context'
  autoload :Trackable,  'vero/trackable'
end

if defined? ActiveRecord
  require 'delayed_job_active_record'
end

if defined? Mongoid
  require 'delayed_job_mongoid'
end

require 'vero/railtie' if defined?(Rails)