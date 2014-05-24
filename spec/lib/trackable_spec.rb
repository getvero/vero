require 'spec_helper'

def vero_context(user, logging = true, async = false)
  context = Vero::Context.new(Vero::App.default_context)
  context.subject = user
  context.config.logging = logging
  context.config.async = async

  context
end

describe Vero::Trackable do
  before :each do
    @request_params = {
      :event_name => 'test_event',
      :auth_token => 'YWJjZDEyMzQ6ZWZnaDU2Nzg=',
      :identity => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
      :data => { :test => 1 },
      :development_mode => true
    }
    @url = "https://api.getvero.com/api/v1/track.json"
    @user = User.new

    @content_type_params = {:content_type => :json, :accept => :json}
  end

  context "the gem has not been configured" do
    before { Vero::App.reset! }
    it "should raise an error when API requests are made" do
      expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to raise_error

      @user.stub(:post_later).and_return('success')
      expect { @user.identity! }.to raise_error
    end
  end

  context "the gem has been configured" do
    before do
      Vero::App.init do |c|
        c.api_key = 'abcd1234'
        c.secret = 'efgh5678'
        c.async = false
      end
    end

    describe :track! do
      before do
        @request_params = {
          :event_name => 'test_event',
          :identity => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
          :data => { :test => 1 },
          :extras => {}
        }
        @url = "https://api.getvero.com/api/v1/track.json"
      end

      it "should not send a track request when the required parameters are invalid" do
        expect { @user.track!(nil) }.to raise_error
        expect { @user.track!('') }.to raise_error
        expect { @user.track!('test', '') }.to raise_error
      end

      it "should send a `track!` request when async is set to false" do
        context = vero_context(@user)
        @user.stub(:with_vero_context).and_return(context)

        RestClient.stub(:post).and_return(200)

        Vero::Api::Events.stub(:track!).and_return(200)
        Vero::Api::Events.should_receive(:track!).with(@request_params, context)
        @user.track!(@request_params[:event_name], @request_params[:data]).should == 200

        Vero::Api::Events.stub(:track!).and_return(200)
        Vero::Api::Events.should_receive(:track!).with(@request_params.merge(:data => {}), context)
        @user.track!(@request_params[:event_name]).should == 200
      end

      context 'when set to be async' do
        before { @user.stub(:with_vero_context).and_return vero_context(@user, true, true) }

        context 'using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.8.7') }

          it 'raises an error' do
            expect { @user.track!(@request_params[:event_name], @request_params[:data]) }.to raise_error
            expect { @user.track!(@request_params[:event_name]) }.to raise_error
          end
        end

        context 'not using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.9.3') }

          it 'sends' do
            @user.track!(@request_params[:event_name], @request_params[:data]).should be_true
            @user.track!(@request_params[:event_name]).should be_true
          end
        end
      end
    end

    describe :identify! do
      before do
        @request_params = {
          :id => nil,
          :email => 'durkster@gmail.com',
          :data => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"}
        }
        @url = "https://api.getvero.com/api/v2/users/track.json"
      end

      it "should send an `identify` request when async is set to false" do
        context = vero_context(@user)
        @user.stub(:with_vero_context).and_return(context)

        Vero::Api::Users.stub(:track!).and_return(200)
        Vero::Api::Users.should_receive(:track!).with(@request_params, context)

        @user.identify!.should == 200
      end

      context 'when set to use async' do
        before do
          context = vero_context(@user, false, true)
          @user.stub(:with_vero_context).and_return(context)
        end

        context 'and using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.8.7') }

          it 'raises an error' do
            expect { @user.identify! }.to raise_error
          end
        end

        context 'and not using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.9.3') }

          it 'sends' do
            @user.identify!.should be_true
          end
        end
      end
    end

    describe :update_user! do
      before do
        @request_params = {
          :id => nil,
          :email => 'durkster@gmail.com',
          :changes => {:email => 'durkster@gmail.com', :age => 20, :_user_type => "User"},
        }
        @url = "https://api.getvero.com/api/v2/users/edit.json"
      end

      it "should send an `update_user` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user

        @user.stub(:with_vero_context).and_return(context)

        Vero::Api::Users.stub(:edit_user!).and_return(200)
        Vero::Api::Users.should_receive(:edit_user!).with(@request_params, context)

        @user.with_vero_context.update_user!.should == 200
      end

      context 'when set to use async' do
        let(:my_context) { Vero::Context.new(Vero::App.default_context) }

        before do
          my_context.subject = @user
          my_context.config.async = true

          @user.stub(:with_vero_context).and_return(my_context)
        end

        context 'and using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.8.7') }

          it 'raises an error' do
            expect { @user.with_vero_context.update_user! }.to raise_error
          end
        end

        context 'and not using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.9.3') }

          it 'sends' do
            @user.with_vero_context.update_user!.should be_true
          end
        end
      end
    end

    describe :update_user_tags! do
      before do
        @request_params = {
          :id => nil,
          :email => 'durkster@gmail.com',
          :add => [],
          :remove => []
        }
        @url = "https://api.getvero.com/api/v2/users/tags/edit.json"
      end

      it "should send an `update_user_tags` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = false

        @user.stub(:with_vero_context).and_return(context)

        Vero::Api::Users.stub(:edit_user_tags!).and_return(200)
        Vero::Api::Users.should_receive(:edit_user_tags!).with(@request_params, context)

        @user.with_vero_context.update_user_tags!.should == 200
      end

      if RUBY_VERSION =~ /1\.9\./
        it "should send using another thread when async is set to true" do
          context = Vero::Context.new(Vero::App.default_context)
          context.subject = @user
          context.config.async = true

          @user.stub(:with_vero_context).and_return(context)

          @user.with_vero_context.update_user_tags!.should be_true
        end
      end
    end

    describe :unsubscribe! do
      before do
        @request_params = {
          :id => nil,
          :email => 'durkster@gmail.com'
        }
        @url = "https://api.getvero.com/api/v2/users/unsubscribe.json"
      end

      it "should send an `update_user` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = false

        @user.stub(:with_vero_context).and_return(context)

        Vero::Api::Users.stub(:unsubscribe!).and_return(200)
        Vero::Api::Users.should_receive(:unsubscribe!).with(@request_params, context)

        @user.with_vero_context.unsubscribe!.should == 200
      end

      context 'when using async' do
        let(:my_context) { Vero::Context.new(Vero::App.default_context) }

        before do
          my_context.subject = @user
          my_context.config.async = true

          @user.stub(:with_vero_context).and_return(my_context)
        end

        context 'and using Ruby 1.8.7' do
          before { stub_const('RUBY_VERSION', '1.8.7') }

          it 'raises an error' do
            expect { @user.with_vero_context.unsubscribe! }.to raise_error
          end
        end

        context 'and using Ruby 1.9.3' do
          before { stub_const('RUBY_VERSION', '1.9.3') }

          it 'sends' do
            @user.with_vero_context.unsubscribe!.should be_true
          end
        end
      end
    end

    describe :trackable do
      before { User.reset_trackable_map! }

      it "should build an array of trackable params" do
        User.trackable :email, :age
        User.trackable_map.should == [:email, :age]
      end

      it "should append new trackable items to an existing trackable map" do
        User.trackable :email, :age
        User.trackable :hair_colour
        User.trackable_map.should == [:email, :age, :hair_colour]
      end

      it "should append an extra's hash to the trackable map" do
        User.trackable :email, {:extras => :properties}
        User.trackable_map.should == [:email, {:extras => :properties}]
      end
    end

    describe :to_vero do
      before :all do
        User.reset_trackable_map!
        User.trackable :email, :age
      end

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

      it "should take into account any defined extras" do
        user = UserWithExtras.new
        user.properties = nil
        user.to_vero.should == {:email => 'durkster@gmail.com', :_user_type => "UserWithExtras"}

        user.properties = "test"
        user.to_vero.should == {:email => 'durkster@gmail.com', :_user_type => "UserWithExtras"}

        user.properties = {}
        user.to_vero.should == {:email => 'durkster@gmail.com', :_user_type => "UserWithExtras"}

        user.properties = {
          :age => 20,
          :gender => "female"
        }
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 20, :gender => "female", :_user_type => "UserWithExtras"}

        user = UserWithPrivateExtras.new
        user.to_vero.should == {:email => 'durkster@gmail.com', :age => 26, :_user_type => "UserWithPrivateExtras"}
      end

      it "should allow extras to be provided instead :id or :email" do
        user = UserWithOnlyExtras.new
        user.properties = {:email => user.email}
        user.to_vero.should == {:email => 'durkster@gmail.com', :_user_type => "UserWithOnlyExtras"}
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
      url = "https://api.getvero.com/api/v1/track.json"

      context = Vero::Context.new(Vero::App.default_context)
      context.subject = user
      context.stub(:post_now).and_return(200)

      user.stub(:with_vero_context).and_return(context)

      RestClient.stub(:post).and_return(200)
      user.vero_track(request_params[:event_name], request_params[:data]).should == 200
    end
  end
end
