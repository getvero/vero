require 'spec_helper'

describe Vero::Api::Workers::Users::ReidentifyAPI do
  subject { Vero::Api::Workers::Users::ReidentifyAPI.new('https://api.getvero.com', {}) }
  it "should inherit from Vero::Api::Workers::BaseCaller" do
    subject.should be_a(Vero::Api::Workers::BaseAPI)
  end

  it "should map to current version of Vero API" do
    subject.send(:url).should == "https://api.getvero.com/api/v2/users/reidentify.json"
  end

  subject { Vero::Api::Workers::Users::ReidentifyAPI.new('https://api.getvero.com', {:auth_token => 'abcd', :id => 'test@test.com', :new_id => 'test2@test.com'}) }
  describe :validate! do
    it "should not raise an error when the keys are Strings" do
      options = {"auth_token" => 'abcd', "id" => 'test@test.com', "new_id" => 'test2@test.com'}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end

    it "should raise an error if id is missing" do
      subject.options = {:auth_token => 'abcd', :new_id => 'test2@test.com'}
      expect { subject.send(:validate!) }.to raise_error
    end

    it "should raise an error if new_id is missing" do
      subject.options = {:auth_token => 'abcd', :id => 'test@test.com'}
      expect { subject.send(:validate!) }.to raise_error
    end
  end

  describe :request do
    it "should send a request to the Vero API" do
      RestClient.should_receive(:put).with("https://api.getvero.com/api/v2/users/reidentify.json", {:auth_token => 'abcd', :id => 'test@test.com', :new_id => 'test2@test.com'}.to_json, {:content_type => :json, :accept => :json})
      RestClient.stub(:put).and_return(200)
      subject.send(:request)
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      RestClient.stub(:put).and_return(200)
      expect { subject.perform }.to_not raise_error
    end
  end
end