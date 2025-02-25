# frozen_string_literal: true

require "spec_helper"

describe Vero::Config do
  subject(:config) { described_class.new }

  it "is async by default" do
    expect(config.async).to be(true)
  end

  describe "#reset!" do
    it "resets all attributes" do
      config.tracking_api_key = "abcd1234"
      config.reset!

      expect(config.tracking_api_key).to be_nil
    end
  end

  describe "#tracking_api_key" do
    it "returns nil if tracking_api_key is not set" do
      config.tracking_api_key = nil
      expect(config.tracking_api_key).to be_nil
    end

    it "returns the expected tracking_api_key" do
      config.tracking_api_key = "abcd1234"
      expect(config.tracking_api_key).to eq("abcd1234")
    end
  end

  describe "#request_params" do
    it "returns a hash containing tracking_api_key if set" do
      config.tracking_api_key = nil
      expect(config.request_params).not_to be_key(:tracking_api_key)

      config.tracking_api_key = "abcd1234"
      expect(config.request_params).to include(tracking_api_key: "abcd1234")
    end
  end

  describe "#domain" do
    it "returns https://api.getvero.com when not set" do
      expect(config.domain).to eq("https://api.getvero.com")
      config.domain = "blah.com"
      expect(config.domain).not_to eq("https://api.getvero.com")
    end

    it "returns the domain value" do
      config.domain = "test.unbelieveable.com.au"
      expect(config.domain).to eq("http://test.unbelieveable.com.au")

      config.domain = "http://test.unbelieveable.com.au"
      expect(config.domain).to eq("http://test.unbelieveable.com.au")
    end
  end

  describe "#test_mode" do
    it "raise nothing even when not configured correctly" do
      input = {event_name: "test_event"}
      mock_context = Vero::Context.new
      allow(mock_context.config).to receive(:configured?).and_return(false)

      expect { Vero::Api::Events.track!(input) }.not_to raise_error
    end
  end
end
