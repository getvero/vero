require 'delayed_job'
require 'vero/jobs/rest_post_job'

module Vero
  module Trackable
    def self.included(base)
      @@vero_trackable_map = []
      base.extend(ClassMethods)
    end

    module ClassMethods
      def trackable(*args)
        @@vero_trackable_map = args
      end

      def trackable_map
        @@vero_trackable_map
      end
    end

    def to_vero
      self.class.trackable_map.inject({}) do |hash, symbol|
        hash[symbol] = self.send(symbol)
        hash
      end
    end

    def track(event_name, event_data = {}, cta = '')
      validate_configured!
      validate_track_params!(event_name, event_data, cta)

      config = Vero::App.config
      request_params = config.request_params
      request_params.merge!(event_name: event_name, identity: self.to_vero, data: event_data, cta: cta)
      
      method = !config.async ? :post_now : :post_later
      self.send(method, "http://#{config.domain}/api/v1/track.json", request_params)
    end

    private
    def post_now(url, params)
      job = Vero::Jobs::RestPostJob.new(url, params)
      job.perform
    end

    def post_later(url, params)
      job = Vero::Jobs::RestPostJob.new(url, params)
      ::Delayed::Job.enqueue job
      'success'
    end

    def validate_configured!
      unless Vero::App.configured?
        raise "You must configure the 'vero' gem. Visit https://bitbucket.org/semblance/vero/overview for more details."
      end
    end

    def validate_track_params!(event_name, event_data, cta)
      result = true

      result &&= event_name.kind_of?(String) && !event_name.blank?
      result &&= event_data.nil? || event_data.kind_of?(Hash)
      result &&= cta.nil? || cta.kind_of?(String)

      raise ArgumentError.new({event_name: event_name, event_data: event_data, cta: cta}) unless result
    end
  end
end