require 'json'
require 'delayed_job'
require 'vero/jobs/rest_post_job'

module Vero
  class Context
    attr_accessor :config, :subject

    def initialize(object = {})
      case object
      when Hash 
        #stub
      when Vero::Context
        @config = object.config
        @subject = object.subject
      else
        object = Vero::Config.available_attributes.inject({}) do |hash, symbol|
          hash[symbol] = object.respond_to?(symbol) ? object.send(symbol) : nil
          hash
        end
      end

      if object.is_a?(Hash)
        @config = Vero::Config.new
        self.configure(object)
      end
    end

    def configure(hash = {}, &block)
      if hash.is_a?(Hash) && hash.any?
        @config.update_attributes(hash)
      end

      block.call(@config) if block_given?
    end

    def reset!
      @config.reset!
    end

    def disable_requests!
      @config.disabled = true
    end

    def configured?
      @config.configured?
    end

    def track(event_name, event_data = {})
      validate_configured!
      validate_track_params!(event_name, event_data)

      request_params = @config.request_params
      request_params.merge!({:event_name => event_name, :identity => subject.to_vero, :data => event_data})
      
      method = if @config.async
        :post_later
      else
        :post_now
      end
      self.send(method, "http://#{@config.domain}/api/v1/track.json", request_params)
    end

    private
    def post_now(url, params)
      unless @config.disabled
        Vero::Jobs::RestPostJob.new(url, params).perform
        Vero::App.log(self, "method: track, params: #{params.to_json}, response: job performed")
      end
    rescue => e
      Vero::App.log(self, "method: track, params: #{params.to_json} error: #{e.message}")
    end

    def post_later(url, params)
      unless @config.disabled
        ::Delayed::Job.enqueue Vero::Jobs::RestPostJob.new(url, params)
        Vero::App.log(self, "method: track, params: #{params.to_json}, response: delayed job queued")
      end

      'success'
    rescue => e
      if e.message == "Could not find table 'delayed_jobs'"
        raise "To send ratings asynchronously, you must configure delayed_job. Run `rails generate delayed_job:active_record` then `rake db:migrate`."
      else
        raise e
      end
    end

    def validate_configured!
      unless @config.configured?
        raise "You must configure the 'vero' gem. Visit https://github.com/semblancesystems/vero for more details."
      end
    end

    def validate_track_params!(event_name, event_data)
      result = true

      result &&= event_name.kind_of?(String) && !event_name.blank?
      result &&= event_data.nil? || event_data.kind_of?(Hash)

      raise ArgumentError.new({:event_name => event_name, :event_data => event_data}) unless result
    end
  end
end