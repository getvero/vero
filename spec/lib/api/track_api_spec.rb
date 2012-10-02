require 'spec_helper'

describe Vero::API::TrackAPI do
  subject { Vero::API::TrackAPI.new('https://www.getvero.com', {}) }
  it "should inherit from Vero::API::BaseCaller" do
    subject.should be_a(Vero::API::BaseAPI)
  end

  it "should map to current version of Vero API" do
    subject.send(:url).should == "https://www.getvero.com/api/v1/track.json"
  end

  subject { Vero::API::TrackAPI.new('https://www.getvero.com', {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'}) }
  describe :validate! do
    it "should raise an error if test_event is a blank String" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => nil}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end

    it "should raise an error if data is not either nil or a Hash" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event', :data => []}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event', :data => nil}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)

      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event', :data => {}}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end
  end
  
  describe :request do
    it "should send a request to the Vero API" do
      RestClient.should_receive(:post).with("https://www.getvero.com/api/v1/track.json", {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'})
      RestClient.stub(:post).and_return(200)
      subject.send(:request)
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      RestClient.stub(:post).and_return(200)
      expect { subject.perform }.to_not raise_error
    end
  end
end