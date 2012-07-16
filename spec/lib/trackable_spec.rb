require 'spec_helper'

describe Vero::Trackable do
  before :each do
    @request_params = {
      :event_name => 'test_event',
      :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
      :identity => {:email => 'durkster@gmail.com', :age => 20},
      :data => { :test => 1 },
      :development_mode => true
    }
    @url = "http://www.getvero.com/api/v1/track.json"
    @user = User.new
  end

  context "the gem has not been configured" do
    before :each do
      Vero::App.reset!
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
    end

    describe :track do
      it "should not send a track request when the required parameters are invalid" do
        @user.stub(:post_now).and_return(200)

        expect { @user.track(nil) }.to raise_error
        expect { @user.track('') }.to raise_error
        expect { @user.track('test', '') }.to raise_error
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

      it "should not raise an error when async is set to false and the request times out" do
        Vero::App.config.async = false
        Vero::App.config.domain = "localhost"
        Rails.stub(:logger).and_return(Logger.new('info'))

        expect { @user.track(@request_params[:event_name], @request_params[:data], 'test') }.to_not raise_error
      end
    end

    describe :trackable do
      after :each do
        User.trackable_map_reset!
        User.trackable :email, :age
      end

      it "should build an array of trackable params" do
        User.trackable_map_reset!
        User.trackable :email, :age
        User.trackable_map.should == [:email, :age]
      end

      it "should append new trackable items to an existing trackable map" do
        User.trackable_map_reset!
        User.trackable :email, :age
        User.trackable :hair_colour
        User.trackable_map.should == [:email, :age, :hair_colour]
      end
    end

    describe :to_vero do
      it "should return a hash of all values mapped by trackable" do
        temp_params = {:email => 'durkster@gmail.com', :age => 20}

        user = User.new
        user.to_vero.should == temp_params

        user = UserWithoutEmail.new
        user.to_vero.should == temp_params

        user = UserWithEmailAddress.new
        user.to_vero.should == temp_params
      end
    end

    describe :execute_unless_disabled do
      it "should only execute the block unless config.disabled" do
        user = User.new
        test_val = 1
        test_val.should == 1

        user.send(:execute_unless_disabled) do 
          test_val = 2
        end
        test_val.should == 2

        Vero::App.disable_requests!
        user.send(:execute_unless_disabled) do 
          test_val = 3
        end
        test_val.should == 2
      end
    end
  end
end