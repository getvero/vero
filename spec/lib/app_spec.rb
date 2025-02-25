# frozen_string_literal: true

require "spec_helper"

describe Vero::App do
  let(:context) { described_class.default_context }

  describe ".default_context" do
    it "inherits from Vero::Context" do
      actual = described_class.default_context
      expect(actual).to be_a(Vero::Context)
    end
  end

  describe ".init" do
    it "ignores configuring the config if no block is provided" do
      described_class.init
      expect(context.configured?).to be(false)
    end

    it "passes configuration defined in the block to the config file" do
      described_class.init

      expect(context.config.tracking_api_key).to be_nil
      described_class.init do |c|
        c.tracking_api_key = "abcd1234"
      end
      expect(context.config.tracking_api_key).to eq("abcd1234")
    end

    it "allows init to set async" do
      described_class.init do |c|
        c.async = false
      end
      expect(context.config.async).to be(false)

      described_class.init do |c|
        c.async = true
      end
      expect(context.config.async).to be(true)
    end
  end

  describe ".disable_requests!" do
    it "changes config.disabled" do
      described_class.init
      expect(context.config.disabled).to be(false)

      described_class.disable_requests!
      expect(context.config.disabled).to be(true)
    end
  end
end
