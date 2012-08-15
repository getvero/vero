require 'spec_helper'

describe Vero::Trackable do
  before :each do
    @request_params = {
      :event_name => 'test_event',
      :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
      :identity => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
      :data => { :test => 1 },
      :development_mode => true
    }
    @url = "https://www.getvero.com/api/v1/track.json"
    @user = User.new
  end

  context "the gem has not been configured" do
    before :each do
      Vero::App.reset!
    end

    describe :track do
      it "should raise an error" do
        expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to raise_error
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
        expect { @user.track(nil) }.to raise_error
        expect { @user.track('') }.to raise_error
        expect { @user.track('test', '') }.to raise_error
      end

      it "should send a track request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.logging = true

        @user.stub(:with_vero_context).and_return(context)

        @user.track(@request_params[:event_name], @request_params[:data]).should == 200
        @user.track(@request_params[:event_name]).should == 200
      end

      it "should create a delayed job when async is set to true" do
        context = Vero::Context.new(Vero::App.default_context)
        context.config.logging = true
        context.subject = @user
        context.config.async = true

        @user.stub(:with_vero_context).and_return(context)

        @user.track(@request_params[:event_name], @request_params[:data]).should == 'success'
        @user.track(@request_params[:event_name]).should == 'success'
      end

      it "should not raise an error when async is set to false and the request times out" do
        Rails.stub(:logger).and_return(Logger.new('info'))
        
        context = Vero::App.default_context
        context.config.async = false
        context.config.domain = "localhost"

        expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to_not raise_error
      end
    end

    describe :trackable do
      after :each do
        User.reset_trackable_map!
        User.trackable :email, :age
      end

      it "should build an array of trackable params" do
        User.reset_trackable_map!
        User.trackable :email, :age
        User.trackable_map.should == [:email, :age]
      end

      it "should append new trackable items to an existing trackable map" do
        User.reset_trackable_map!
        User.trackable :email, :age
        User.trackable :hair_colour
        User.trackable_map.should == [:email, :age, :hair_colour]
      end
    end

    describe :to_vero do
      it "should return a hash of all values mapped by trackable" do
        user = User.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"}

        user = UserWithoutEmail.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 20, :_user_type => "UserWithoutEmail"}

        user = UserWithEmailAddress.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 20, :_user_type => "UserWithEmailAddress"}
      end
    end
  end
end