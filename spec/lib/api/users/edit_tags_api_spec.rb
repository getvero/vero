require 'spec_helper'

describe Vero::Api::Workers::Users::EditTagsAPI do
  subject { Vero::Api::Workers::Users::EditTagsAPI.new('https://api.getvero.com', {}) }
  it "should inherit from Vero::Api::Workers::BaseCaller" do
    subject.should be_a(Vero::Api::Workers::BaseAPI)
  end

  it "should map to current version of Vero API" do
    subject.send(:url).should == "https://api.getvero.com/api/v2/users/tags/edit.json"
  end

  subject { Vero::Api::Workers::Users::EditTagsAPI.new('https://api.getvero.com', {:auth_token => 'abcd', :email => 'test@test.com', :add => ["test"]}) }

  describe :validate! do
    it "should raise an error if email is a blank String" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => nil, :add => []}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => 'test@test.com', :add => []}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end

    it "should raise an error if add is not an Array or missing" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => 'test@test.com', :add => "foo" }

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "should raise an error if remove is not an Array or missing" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => 'test@test.com', :remove => "foo" }

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "should raise an error if botha add and remove are missing" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => 'test@test.com'}

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "should not raise an error if the correct arguments are passed" do
      options = {:auth_token => 'abcd', :identity => {:email => 'test@test.com'}, :email => 'test@test.com', :remove => [ "Hi" ] }

      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end

    it "should not raise an error when the keys are Strings" do
      options = {"auth_token" => 'abcd', "identity" => {"email" => 'test@test.com'}, "email" => 'test@test.com', "remove" => [ "Hi" ] }
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error(ArgumentError)
    end
  end

  describe :request do
    it "should send a request to the Vero API" do
      RestClient.should_receive(:put).with("https://api.getvero.com/api/v2/users/tags/edit.json", {:auth_token => 'abcd', :email => 'test@test.com', :add => ["test"]}.to_json, {:content_type => :json, :accept => :json})
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
