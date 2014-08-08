require 'spec_helper'

describe Vero::Config do
  before :each do
    @config = Vero::Config.new
  end

  it "should be async by default" do
    @config.async.should be(true)
  end

  describe :reset! do
    it "should reset all attributes" do
      @config.api_key = "abcd1234"
      @config.secret  = "abcd1234"

      @config.reset!
      @config.api_key.should be_nil
      @config.secret.should be_nil
    end
  end

  describe :auth_token do
    it "should return nil if either api_key or secret are not set" do
      @config.api_key = nil
      @config.secret = "abcd"
      @config.auth_token.should be_nil

      @config.api_key = "abcd"
      @config.secret = nil
      @config.auth_token.should be_nil

      @config.api_key = "abcd"
      @config.secret = "abcd"
      @config.auth_token.should_not be_nil
    end

    it "should return an expected auth_token" do
      @config.api_key = "abcd1234"
      @config.secret = "efgh5678"
      @config.auth_token.should == "YWJjZDEyMzQ6ZWZnaDU2Nzg="
    end
  end

  describe :request_params do
    it "should return a hash of auth_token and development_mode if they are set" do
      @config.api_key = nil
      @config.secret = nil
      @config.development_mode = nil
      @config.request_params.should == {}

      @config.api_key = "abcd1234"
      @config.secret = "abcd1234"
      @config.request_params.should == {:auth_token => "YWJjZDEyMzQ6YWJjZDEyMzQ="}

      @config.development_mode = true
      @config.request_params.should == {:auth_token => "YWJjZDEyMzQ6YWJjZDEyMzQ=", :development_mode => true}
    end
  end

  describe :domain do
    it "should return https://api.getvero.com when not set" do
      @config.domain.should == 'https://api.getvero.com'
      @config.domain = 'blah.com'
      @config.domain.should_not == 'https://api.getvero.com'
    end

    it "should return the domain value" do
      @config.domain = 'test.unbelieveable.com.au'
      @config.domain.should == 'http://test.unbelieveable.com.au'

      @config.domain = 'http://test.unbelieveable.com.au'
      @config.domain.should == 'http://test.unbelieveable.com.au'
    end
  end

  describe :development_mode do
    it "by default it should return true when Rails.env is either development or test" do
      stub_env('development') {
        config = Vero::Config.new
        config.development_mode.should be(true)
      }

      stub_env('test') {
        config = Vero::Config.new
        config.development_mode.should be(true)
      }

      stub_env('production') {
        config = Vero::Config.new
        config.development_mode.should be(false)
      }
    end
  end
end