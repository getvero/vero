# frozen_string_literal: true

require "spec_helper"

describe Vero::Context do
  let(:context) { described_class.new }

  describe "#initialize" do
    it "accepts multiple parameter types" do
      context1 = described_class.new({tracking_api_key: "didah"})
      expect(context1.config.tracking_api_key).to eq("didah")

      context2 = described_class.new(context1)
      expect(context2).not_to be(context1)
      expect(context2.config.tracking_api_key).to eq("didah")

      context3 = described_class.new VeroUser.new("tracking_api_key")
      expect(context3.config.tracking_api_key).to eq("tracking_api_key")
    end
  end

  describe "#configure" do
    it "ignores configuring the config if no block is provided" do
      context.configure
      expect(context.configured?).to be(false)
    end

    it "passes configuration defined in the block to the config file" do
      context.configure do |c|
        c.tracking_api_key = "abcd1234"
      end
      expect(context.config.tracking_api_key).to eq("abcd1234")
    end

    it "allows init to set async" do
      context.configure do |c|
        c.async = false
      end
      expect(context.config.async).to be(false)

      context.configure do |c|
        c.async = true
      end
      expect(context.config.async).to be(true)
    end
  end

  describe "#disable_requests!" do
    it "changes config.disabled" do
      expect(context.config.disabled).to be(false)
      context.disable_requests!
      expect(context.config.disabled).to be(true)
    end
  end
end
