require 'rest-client'
require 'vero/utility/ext'

module Vero
  autoload :Config,               'vero/config'
  autoload :App,                  'vero/app'
  autoload :Context,              'vero/context'
  autoload :APIContext,           'vero/context/api'
  autoload :Trackable,            'vero/trackable'
  autoload :DSL,                  'vero/dsl'
  autoload :Sender,               'vero/sender'
  autoload :ResqueWorker,         'vero/senders/resque'
  autoload :SidekiqWorker,        'vero/senders/sidekiq'

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
        autoload :ReidentifyAPI,  'vero/api/users/reidentify_api'
      end
    end

    autoload :Events,             'vero/api'
    autoload :Users,              'vero/api'
  end

  module Senders
    autoload :Base,               'vero/senders/base'
    autoload :DelayedJob,         'vero/senders/delayed_job'
    autoload :Resque,             'vero/senders/resque'
    autoload :Sidekiq,            'vero/senders/sidekiq'
    autoload :Invalid,            'vero/senders/invalid'
    autoload :Thread,             'vero/senders/thread'
  end

  module Utility
    autoload :Logger,             'vero/utility/logger'
  end
end

require 'vero/railtie' if defined?(Rails)
