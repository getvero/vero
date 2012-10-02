require 'rails'
require 'rest-client'

module Vero 
  autoload :Config,       'vero/config'
  autoload :App,          'vero/app'
  autoload :Context,      'vero/context'
  autoload :Trackable,    'vero/trackable'
  
  module API
    autoload :BaseAPI,    'vero/api/base_api'
    autoload :TrackAPI,   'vero/api/track_api'
    autoload :UserAPI,    'vero/api/user_api'
  end
  
  module Utility
    autoload :Logger,     'vero/utility/logger'
  end

  module Senders
    autoload :Base,       'vero/senders/base'
    autoload :DelayedJob, 'vero/senders/delayed_job'
    autoload :Thread,     'vero/senders/thread'
  end
  autoload :Sender,       'vero/sender'
end

if defined? ActiveRecord
  require 'delayed_job_active_record'
end

if defined? Mongoid
  require 'delayed_job_mongoid'
end

require 'vero/railtie' if defined?(Rails)