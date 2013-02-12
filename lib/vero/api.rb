module Vero
  module Api
    class Base
      attr_accessor :context

      def initialize(context)
        self.context = context
      end

      def config
        self.context.config
      end

      protected
      def validate_configured!
        unless config.configured?
          raise "You must configure the 'vero' gem. Visit https://github.com/semblancesystems/vero for more details."
        end
      end
    end

    class Events < Base
      def self.track!(options, context = Vero::App.default_context)
        new(context).track!(options)
      end

      def track!(options)
        validate_configured!

        options.merge!(config.request_params)
        unless config.disabled
          Vero::Sender.send Vero::Api::Workers::Events::TrackAPI, config.async, config.domain, options
        end
      end
    end

    class Users < Base
      def self.track!(options, context = Vero::App.default_context)
        new(context).track!(options)
      end

      def self.edit_user!(options, context = Vero::App.default_context)
        new(context).edit_user!(options)
      end

      def self.edit_user_tags!(options, context = Vero::App.default_context)
        new(context).edit_user_tags!(options)
      end

      def self.unsubscribe!(options, context = Vero::App.default_context)
        new(context).unsubscribe!(options)
      end

      def track!(options)
        validate_configured!

        options.merge!(config.request_params)
        unless config.disabled
          Vero::Sender.send Vero::Api::Workers::Users::TrackAPI, config.async, config.domain, options
        end
      end

      def edit_user!(options)
        validate_configured!
        options.merge!(config.request_params)

        unless config.disabled
          Vero::Sender.send Vero::Api::Workers::Users::EditAPI, config.async, config.domain, options
        end
      end

      def edit_user_tags!(options)
        validate_configured!
        
        options.merge!(config.request_params)

        unless config.disabled
          Vero::Sender.send Vero::Api::Workers::Users::EditTagsAPI, config.async, config.domain, options
        end
      end

      def unsubscribe!(options)
        validate_configured!
        
        options.merge!(config.request_params)

        unless config.disabled
          Vero::Sender.send Vero::Api::Workers::Users::UnsubscribeAPI, config.async, config.domain, options
        end
      end
    end
  end
end
