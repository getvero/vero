require 'spec_helper'

describe Vero::Context do 
  let(:context) { Vero::Context.new }

  it "accepts multiple parameter types in contructor" do
    context1 = Vero::Context.new({ :api_key => 'blah', :secret => 'didah' })
    expect(context1).to be_a(Vero::Context)
    expect(context1.config.api_key).to eq('blah')
    expect(context1.config.secret).to eq('didah')

    context2 = Vero::Context.new(context1)
    expect(context2).to be_a(Vero::Context)
    expect(context2).not_to be(context1)
    expect(context2.config.api_key).to eq('blah')
    expect(context2.config.secret).to eq('didah')

    context3 = Vero::Context.new VeroUser.new('api_key', 'secret')
    expect(context3).to be_a(Vero::Context)
    expect(context3.config.api_key).to eq('api_key')
    expect(context3.config.secret).to eq('secret')
  end

  describe :configure do
    it "should ignore configuring the config if no block is provided" do
      context.configure
      expect(context.configured?).to be(false)
    end

    it "should pass configuration defined in the block to the config file" do
      context.configure do |c|
        c.api_key = "abcd1234"
      end
      expect(context.config.api_key).to eq("abcd1234")
    end

    it "should init should be able to set async" do
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

  describe :disable_requests! do
    it "should change config.disabled" do
      expect(context.config.disabled).to be(false)
      context.disable_requests!
      expect(context.config.disabled).to be(true)            
    end
  end
end