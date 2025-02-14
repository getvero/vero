# frozen_string_literal: true

require "spec_helper"

describe Vero::Config do
  let(:config) { Vero::Config.new }

  it "should be async by default" do
    expect(config.async).to be(true)
  end

  describe :reset! do
    it "should reset all attributes" do
      config.tracking_api_key = "abcd1234"
      config.reset!

      expect(config.tracking_api_key).to be_nil
    end
  end

  describe :tracking_api_key do
    it "should return nil if tracking_api_key is not set" do
      config.tracking_api_key = nil
      expect(config.tracking_api_key).to be_nil
    end

    it "should return an expected tracking_api_key" do
      config.tracking_api_key = "abcd1234"
      expect(config.tracking_api_key).to eq("abcd1234")
    end
  end

  describe :request_params do
    it "should return a hash of tracking_api_key and development_mode if they are set" do
      config.tracking_api_key = nil
      config.development_mode = nil
      expect(config.request_params).to eq({})

      config.tracking_api_key = "abcd1234"
      expect(config.request_params).to eq({tracking_api_key: "abcd1234"})

      config.development_mode = true
      expect(config.request_params).to eq({tracking_api_key: "abcd1234", development_mode: true})
    end
  end

  describe :domain do
    it "should return https://api.getvero.com when not set" do
      expect(config.domain).to eq("https://api.getvero.com")
      config.domain = "blah.com"
      expect(config.domain).not_to eq("https://api.getvero.com")
    end

    it "should return the domain value" do
      config.domain = "test.unbelieveable.com.au"
      expect(config.domain).to eq("http://test.unbelieveable.com.au")

      config.domain = "http://test.unbelieveable.com.au"
      expect(config.domain).to eq("http://test.unbelieveable.com.au")
    end
  end

  describe :development_mode do
    it "by default it should return false regardless of Rails environment" do
      stub_env("development") do
        config = Vero::Config.new
        expect(config.development_mode).to be(false)
      end

      stub_env("test") do
        config = Vero::Config.new
        expect(config.development_mode).to be(false)
      end

      stub_env("production") do
        config = Vero::Config.new
        expect(config.development_mode).to be(false)
      end
    end

    it "can be overritten with the config block" do
      config.development_mode = true
      expect(config.request_params[:development_mode]).to be(true)

      config.reset!
      expect(config.request_params[:development_mode]).to be(false)
    end
  end

  describe :test_mode do
    it "should not raise error even though not configured properly" do
      input = {event_name: "test_event"}
      mock_context = Vero::Context.new
      allow(mock_context.config).to receive(:configured?).and_return(false)

      expect { Vero::Api::Events.track!(input) }.to_not raise_error
    end
  end
end
