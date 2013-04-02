require 'spec_helper'

describe Vero::Api::Workers::Events::TrackAPI do

  context "request without properties" do
    subject { Vero::Api::Workers::Events::TrackAPI.new('https://www.getvero.com', {}) }
    it "should inherit from Vero::Api::Workers::BaseCaller" do
      subject.should be_a(Vero::Api::Workers::BaseAPI)
    end

    it "should map to current version of Vero API" do
      subject.send(:url).should == "https://www.getvero.com/api/v2/events/track.json"
    end
  end

  context "request with properties" do
    subject { Vero::Api::Workers::Events::TrackAPI.new('https://www.getvero.com', {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'}) }
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

      it "should not raise an error when the keys are Strings" do
        options = {"auth_token" => 'abcd', "identity" => {"email" => 'test@test.com'}, "event_name" => 'test_event', "data" => {}}
        subject.options = options
        expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
      end
    end
    
    describe :request do
      it "should send a JSON request to the Vero API" do
        RestClient.should_receive(:post).with("https://www.getvero.com/api/v2/events/track.json", {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'}.to_json, {:content_type => :json, :accept => :json})
        RestClient.stub(:post).and_return(200)
        subject.send(:request)
      end
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      obj = Vero::Api::Workers::Events::TrackAPI.new('https://www.getvero.com', {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :event_name => 'test_event'})

      RestClient.stub(:post).and_return(200)
      expect { obj.perform }.to_not raise_error
    end
  end
end