# frozen_string_literal: true

require "spec_helper"

describe Vero::App do
  let(:context) { Vero::App.default_context }

  describe ".default_context" do
    it "inherits from Vero::Context" do
      actual = Vero::App.default_context
      expect(actual).to be_a(Vero::Context)
    end
  end

  describe ".init" do
    it "ignores configuring the config if no block is provided" do
      Vero::App.init
      expect(context.configured?).to be(false)
    end

    it "passes configuration defined in the block to the config file" do
      Vero::App.init

      expect(context.config.tracking_api_key).to be_nil
      Vero::App.init do |c|
        c.tracking_api_key = "abcd1234"
      end
      expect(context.config.tracking_api_key).to eq("abcd1234")
    end

    it "allows init to set async" do
      Vero::App.init do |c|
        c.async = false
      end
      expect(context.config.async).to be(false)

      Vero::App.init do |c|
        c.async = true
      end
      expect(context.config.async).to be(true)
    end
  end

  describe ".disable_requests!" do
    it "changes config.disabled" do
      Vero::App.init
      expect(context.config.disabled).to be(false)

      Vero::App.disable_requests!
      expect(context.config.disabled).to be(true)
    end
  end

  describe ".log" do
    it "should have a log method" do
      Vero::App.init
      expect(Vero::App).to receive(:log)
      Vero::App.log(Object, "test")
    end
  end
end
