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
        expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to raise_error(RuntimeError, "You must configure the 'vero' gem. Visit https://github.com/semblancesystems/vero for more details.")
      end
    end

    describe :identity! do
      it "should raise an error" do
        @user.stub(:post_later).and_return('success')
        expect { @user.identity! }.to raise_error
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
      before do
        @request_params = {
          :event_name => 'test_event',
          :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
          :identity => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
          :data => { :test => 1 },
          :development_mode => true
        }
        @url = "https://www.getvero.com/api/v1/track.json"
      end

      it "should not send a track request when the required parameters are invalid" do
        expect { @user.track(nil) }.to raise_error(ArgumentError, "{:event_name=>nil, :data=>{}}")
        expect { @user.track('') }.to raise_error(ArgumentError, "{:event_name=>\"\", :data=>{}}")
        expect { @user.track('test', '') }.to raise_error(ArgumentError, "{:event_name=>\"test\", :data=>\"\"}")
      end

      it "should send a `track` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.logging = true

        @user.stub(:with_vero_context).and_return(context)

        RestClient.stub(:post).and_return(200)

        RestClient.should_receive(:post).with("https://www.getvero.com/api/v2/events/track.json", {:auth_token=>"YWJjZDEyMzQ6ZWZnaDU2Nzg=", :development_mode=>true, :data=>{:test=>1}, :event_name=>"test_event", :identity=>{:email=>"durkster@gmail.com", :age=>20, :_user_type=>"User"}})
        @user.track(@request_params[:event_name], @request_params[:data]).should == 200

        RestClient.should_receive(:post).with("https://www.getvero.com/api/v2/events/track.json", {:auth_token=>"YWJjZDEyMzQ6ZWZnaDU2Nzg=", :development_mode=>true, :data=>{}, :event_name=>"test_event", :identity=>{:email=>"durkster@gmail.com", :age=>20, :_user_type=>"User"}})
        @user.track(@request_params[:event_name]).should == 200
      end

      it "should send using another thread when async is set to true" do
        context = Vero::Context.new(Vero::App.default_context)
        context.config.logging = true
        context.subject = @user
        context.config.async = true

        @user.stub(:with_vero_context).and_return(context)

        @user.track(@request_params[:event_name], @request_params[:data]).should be_true
        @user.track(@request_params[:event_name]).should be_true
      end

      # it "should raise an error when async is set to false and the request times out" do
      #   Rails.stub(:logger).and_return(Logger.new('info'))
      #   context = Vero::App.default_context
      #   context.config.async = false
      #   context.config.domain = "200.200.200.200"

      #   expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to raise_error
      # end
    end

    describe :identify! do
      before do
        @request_params = {
          :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
          :data => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
          :development_mode => true,
          :email => 'durkster@gmail.com'
        }
        @url = "https://www.getvero.com/api/v2/users/track.json"
      end

      it "should send an `identify` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user

        @user.stub(:with_vero_context).and_return(context)

        RestClient.stub(:post).and_return(200)
        RestClient.should_receive(:post).with(@url, @request_params)
        
        @user.identify!.should == 200
      end

      it "should send using another thread when async is set to true" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = true

        @user.stub(:with_vero_context).and_return(context)

        @user.identify!.should be_true
      end
    end

    describe :update_user! do
      before do
        @request_params = {
          :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
          :changes => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
          :email => 'durkster@gmail.com',
          :development_mode => true
        }
        @url = "https://www.getvero.com/api/v2/users/edit.json"
      end

      it "should be able to choose an email address" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user

        @user.stub(:with_vero_context).and_return(context)

        RestClient.stub(:put).and_return(200)
        RestClient.should_receive(:put).with(@url, @request_params.merge(:email => "durkster1@gmail.com"))
        
        @user.with_vero_context.update_user!("durkster1@gmail.com").should == 200
      end

      it "should send an `update_user` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user

        @user.stub(:with_vero_context).and_return(context)

        RestClient.stub(:put).and_return(200)
        RestClient.should_receive(:put).with(@url, @request_params)
        
        @user.with_vero_context.update_user!.should == 200
      end

      it "should send using another thread when async is set to true" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = true

        @user.stub(:with_vero_context).and_return(context)

        @user.with_vero_context.update_user!.should be_true
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

        user = UserWithoutInterface.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 20, :_user_type => "UserWithoutInterface"}

        user = UserWithNilAttributes.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :_user_type => "UserWithNilAttributes"}
      end
    end

    describe :with_vero_context do
      it "should be able to change contexts" do
        user = User.new
        user.with_default_vero_context.config.config_params.should == {:api_key=>"abcd1234", :secret=>"efgh5678"}
        user.with_vero_context({:api_key => "boom", :secret => "tish"}).config.config_params.should == {:api_key=>"boom", :secret=>"tish"}
      end
    end
    
    it "should work when Vero::Trackable::Interface is not included" do
      user = UserWithoutInterface.new

      request_params = {
        :event_name => 'test_event',
        :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
        :identity => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "UserWithoutInterface"},
        :data => { :test => 1 },
        :development_mode => true
      }
      url = "https://www.getvero.com/api/v1/track.json"

      context = Vero::Context.new(Vero::App.default_context)
      context.subject = user
      context.stub(:post_now).and_return(200)

      user.stub(:with_vero_context).and_return(context)

      RestClient.stub(:post).and_return(200)
      user.vero_track(request_params[:event_name], request_params[:data]).should == 200
    end
  end
end