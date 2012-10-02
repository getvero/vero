require 'rails'
require 'rest-client'

module Vero 
  autoload :Config,       'vero/config'
  autoload :App,          'vero/app'
  autoload :Context,      'vero/context'
  autoload :Trackable,    'vero/trackable'
  
  module API
    autoload :BaseAPI,    'vero/api/base_api'

    module Events
      autoload :TrackAPI, 'vero/api/events/track_api'
    end

    module Users
      autoload :TrackAPI, 'vero/api/users/track_api'
      autoload :EditAPI,  'vero/api/users/edit_api'
    end
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