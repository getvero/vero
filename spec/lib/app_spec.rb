require 'spec_helper'

describe Vero::App do
  describe "#init" do
    it "should create a Config object" do
      Vero::App.config.should be_nil
      Vero::App.init {}
      Vero::App.config.should_not be_nil
    end

    it "should ignore configuring the config if no block is provided" do
      Vero::App.init
      Vero::App.configured?.should be_false
    end

    it "should pass configuration defined in the block to the config file" do
      Vero::App.init

      Vero::App.config.api_key.should be_nil
      Vero::App.init do |c|
        c.api_key = "abcd1234"
      end
      Vero::App.config.api_key.should == "abcd1234"
    end

    it "should init should be able to set async" do
      Vero::App.init do |c|
        c.async = false
      end
      Vero::App.config.async.should be_false

      Vero::App.init do |c|
        c.async = true
      end
      Vero::App.config.async.should be_true
    end
  end
end