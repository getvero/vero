require 'spec_helper'

describe Vero::Api::Workers::Users::ResubscribeAPI do
  describe 'config' do
    subject { Vero::Api::Workers::Users::ResubscribeAPI.new('https://api.getvero.com', {}) }
    it "should inherit from Vero::Api::Workers::BaseCaller" do
      subject.should be_a(Vero::Api::Workers::BaseAPI)
    end

    it "should map to current version of Vero API" do
      subject.send(:url).should == "https://api.getvero.com/api/v2/users/resubscribe.json"
    end
  end

  subject { Vero::Api::Workers::Users::ResubscribeAPI.new('https://api.getvero.com', {:auth_token => 'abcd', :id => '1234'}) }
  describe :validate! do
    it "should not raise an error when the keys are Strings" do
      subject.options = {"auth_token" => 'abcd', "id" => '1234'}
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it "should raise an error for missing keys" do
      subject.options = {"auth_token" => 'abcd'}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end
  end

  describe :request do
    it "should send a request to the Vero API" do
      RestClient.should_receive(:post).with("https://api.getvero.com/api/v2/users/resubscribe.json", {:auth_token => 'abcd', :id => '1234'})
      RestClient.stub(:post).and_return(200)
      subject.send(:request)
    end
  end
end
