require 'spec_helper'

describe Vero::API::Users::EditAPI do
  subject { Vero::API::Users::EditAPI.new('https://www.getvero.com', {}) }
  it "should inherit from Vero::API::BaseCaller" do
    subject.should be_a(Vero::API::BaseAPI)
  end

  it "should map to current version of Vero API" do
    subject.send(:url).should == "https://www.getvero.com/api/v2/users/edit.json"
  end

  subject { Vero::API::Users::EditAPI.new('https://www.getvero.com', {:auth_token => 'abcd', :email => 'test@test.com', :changes => { :email => 'test@test.com' }}) }
  describe :validate! do
  end

  describe :request do
    it "should send a request to the Vero API" do
      RestClient.should_receive(:put).with("https://www.getvero.com/api/v2/users/edit.json", {:auth_token => 'abcd', :email => 'test@test.com', :changes => { :email => 'test@test.com' }}.to_json, {:content_type => :json, :accept => :json})
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