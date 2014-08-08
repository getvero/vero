require 'spec_helper'

describe Vero::App do
  describe 'self.default_context' do
    it "inherits from Vero::Context" do
      actual = Vero::App.default_context
      actual.should be_a(Vero::Context)
    end
  end

  let (:context) { Vero::App.default_context }
  describe :init do
    it "should ignore configuring the config if no block is provided" do
      Vero::App.init
      context.configured?.should be(false)
    end

    it "should pass configuration defined in the block to the config file" do
      Vero::App.init

      context.config.api_key.should be_nil
      Vero::App.init do |c|
        c.api_key = "abcd1234"
      end
      context.config.api_key.should == "abcd1234"
    end

    it "should init should be able to set async" do
      Vero::App.init do |c|
        c.async = false
      end
      context.config.async.should be(false)

      Vero::App.init do |c|
        c.async = true
      end
      context.config.async.should be(true)
    end
  end

  describe :disable_requests! do
    it "should change config.disabled" do
      Vero::App.init {}
      context.config.disabled.should be(false)

      Vero::App.disable_requests!
      context.config.disabled.should be(true)
    end
  end

  describe :log do
    it "should have a log method" do
      Vero::App.init {}
      Vero::App.should_receive(:log)
      Vero::App.log(Object, "test")
    end
  end
end
