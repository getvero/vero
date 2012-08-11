require 'spec_helper'

describe Vero::Context do 
  let(:context) { Vero::Context.new }
  describe :configure do
    it "should ignore configuring the config if no block is provided" do
      context.configure
      context.configured?.should be_false
    end

    it "should pass configuration defined in the block to the config file" do
      context.configure do |c|
        c.api_key = "abcd1234"
      end
      context.config.api_key.should == "abcd1234"
    end

    it "should init should be able to set async" do
      context.configure do |c|
        c.async = false
      end
      context.config.async.should be_false

      context.configure do |c|
        c.async = true
      end
      context.config.async.should be_true
    end
  end

  describe :disable_requests! do
    it "should change config.disabled" do
      context.config.disabled.should be_false
      context.disable_requests!
      context.config.disabled.should be_true            
    end
  end
end