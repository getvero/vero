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

      def run_api(api_klass, options)
        validate_configured!
        options.merge!(config.request_params)

        unless config.disabled
          Vero::Sender.send(api_klass, config.async, config.domain, options)
        end
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
        run_api(Vero::Api::Workers::Events::TrackAPI, options)
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
        run_api(Vero::Api::Workers::Users::TrackAPI, options)
      end

      def edit_user!(options)
        run_api(Vero::Api::Workers::Users::EditAPI, options)
      end

      def edit_user_tags!(options)
        run_api(Vero::Api::Workers::Users::EditTagsAPI, options)
      end

      def unsubscribe!(options)
        run_api(Vero::Api::Workers::Users::UnsubscribeAPI, options)
      end

      def reidentify!(options)
        run_api(Vero::Api::Workers::Users::ReidentifyAPI, options)
      end
    end
  end
end
