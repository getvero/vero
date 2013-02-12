require 'rest-client'
require 'vero/utility/ext'

module Vero 
  autoload :Config,             'vero/config'
  autoload :App,                'vero/app'
  autoload :Context,            'vero/context'
  autoload :Trackable,          'vero/trackable'
  
  module Api
    module Workers
      autoload :BaseAPI,          'vero/api/base_api'

      module Events
        autoload :TrackAPI,       'vero/api/events/track_api'
      end

      module Users
        autoload :TrackAPI,       'vero/api/users/track_api'
        autoload :EditAPI,        'vero/api/users/edit_api'
        autoload :EditTagsAPI,    'vero/api/users/edit_tags_api'
        autoload :UnsubscribeAPI, 'vero/api/users/unsubscribe_api'
      end
    end
  end
  
  module Utility
    autoload :Logger,           'vero/utility/logger'
  end

  module Senders
    autoload :Base,             'vero/senders/base'
    autoload :DelayedJob,       'vero/senders/delayed_job'
    autoload :Invalid,          'vero/senders/invalid'
    autoload :Thread,           'vero/senders/thread'
  end
  autoload :Sender,             'vero/sender'
end

require 'vero/railtie' if defined?(Rails)