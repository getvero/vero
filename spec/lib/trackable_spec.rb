require 'spec_helper'

describe Vero::Trackable do
  context "the gem has not been configured" do
    before :each do
      Vero::App.reset!
      @request_params = {
        event_name: 'test_event',
        auth_token: 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
        identity: {email: 'durkster@gmail.com', age: 20},
        data: { test: 1 },
        cta: 'test',
        development_mode: true
      }
      @url = "http://www.getvero.com/api/v1/track.json"
      @user = User.new
    end

    describe :track do
      it "should raise an error" do
        @user.stub(:post_later).and_return('success')
        expect { @user.track(@request_params[:event_name], @request_params[:data], 'test') }.to raise_error
      end
    end
  end

  context "the gem has been configured" do
    before :each do
      Vero::App.init do |c|
        c.api_key = 'abcd1234'
        c.secret = 'efgh5678'
        c.async = false
      end
      @user = User.new
    end

    describe "#track" do
      before :each do
        @request_params = {
          event_name: 'test_event',
          auth_token: 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
          identity: {email: 'durkster@gmail.com', age: 20},
          data: { test: 1 },
          cta: 'test',
          development_mode: true
        }
        @url = "http://www.getvero.com/api/v1/track.json"
      end

      it "should send a track request when async is set to false" do
        @user.stub(:post_now).and_return(200)
        @user.should_receive(:post_now).with(@url, @request_params).at_least(:once)
        @user.track(@request_params[:event_name], @request_params[:data], 'test').should == 200
        @user.track(@request_params[:event_name]).should == 200
      end

      it "should create a delayed job when async is set to true" do
        @user.stub(:post_later).and_return('success')
        @user.should_receive(:post_later).with(@url, @request_params).at_least(:once)
        
        Vero::App.config.async = true
        @user.track(@request_params[:event_name], @request_params[:data], 'test').should == 'success'
        @user.track(@request_params[:event_name]).should == 'success'
      end

      it "should not send a track request when the required parameters are invalid" do
        @user.stub(:post_now).and_return(200)

        expect { @user.track(nil) }.to raise_error
        expect { @user.track('') }.to raise_error
        expect { @user.track('test', '') }.to raise_error
        expect { @user.track('test', {}, 8) }.to raise_error
      end
    end
  end
end