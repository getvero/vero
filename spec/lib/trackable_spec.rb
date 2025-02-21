# frozen_string_literal: true

require "spec_helper"

def vero_context(user, logging = true, async = false, disabled = true)
  context = Vero::Context.new(Vero::App.default_context)
  context.subject = user
  context.config.logging = logging
  context.config.async = async
  context.config.disabled = disabled

  context
end

describe Vero::Trackable do
  before do
    @request_params = {
      event_name: "test_event",
      tracking_api_key: "YWJjZDEyMzQ6ZWZnaDU2Nzg=",
      identity: {email: "user@getvero.com", age: 20, _user_type: "User"},
      data: {test: 1}
    }
    @url = "https://api.getvero.com/api/v1/track.json"
    @user = User.new

    @content_type_params = {content_type: :json, accept: :json}
  end

  context "the gem has not been configured" do
    before { Vero::App.reset! }
    it "should raise an error when API requests are made" do
      expect { @user.track(@request_params[:event_name], @request_params[:data]) }.to raise_error(RuntimeError)

      allow(@user).to receive(:post_later).and_return("success")
      expect { @user.identity! }.to raise_error(NoMethodError)
    end
  end

  context "the gem has been configured" do
    before do
      Vero::App.init do |c|
        c.tracking_api_key = "YWJjZDEyMzQ6ZWZnaDU2Nzg="
        c.async = false
      end
    end

    describe :track! do
      before do
        @request_params = {
          event_name: "test_event",
          identity: {email: "user@getvero.com", age: 20, _user_type: "User"},
          data: {test: 1},
          extras: {}
        }
        @url = "https://api.getvero.com/api/v1/track.json"
      end

      it "should not send a track request when the required parameters are invalid" do
        expect { @user.track!(nil) }.to raise_error(ArgumentError)
        expect { @user.track!("") }.to raise_error(ArgumentError)
        expect { @user.track!("test", "") }.to raise_error(ArgumentError)
      end

      it "should send a `track!` request when async is set to false" do
        context = vero_context(@user)
        allow(@user).to receive(:with_vero_context).and_return(context)

        allow(Vero::Api::Events).to receive(:track!).and_return(200)
        expect(Vero::Api::Events).to receive(:track!).with(@request_params, context)
        expect(@user.track!(@request_params[:event_name], @request_params[:data])).to eq(200)

        allow(Vero::Api::Events).to receive(:track!).and_return(200)
        expect(Vero::Api::Events).to receive(:track!).with(@request_params.merge(data: {}), context)
        expect(@user.track!(@request_params[:event_name])).to eq(200)
      end

      context "when set to be async" do
        before do
          @context = vero_context(@user, true, true)
          allow(@user).to receive(:with_vero_context).and_return(@context)
        end

        it "sends" do
          expect(@user.track!(@request_params[:event_name], @request_params[:data])).to be_nil
          expect(@user.track!(@request_params[:event_name])).to be_nil
        end
      end
    end

    describe :identify! do
      before do
        @request_params = {
          id: nil,
          email: "user@getvero.com",
          data: {email: "user@getvero.com", age: 20, _user_type: "User"}
        }
        @url = "https://api.getvero.com/api/v2/users/track.json"
      end

      it "should send an `identify` request when async is set to false" do
        context = vero_context(@user)
        allow(@user).to receive(:with_vero_context).and_return(context)

        allow(Vero::Api::Users).to receive(:track!).and_return(200)
        expect(Vero::Api::Users).to receive(:track!).with(@request_params, context)

        expect(@user.identify!).to eq(200)
      end

      context "when set to use async" do
        before do
          @context = vero_context(@user, false, true)
          allow(@user).to receive(:with_vero_context).and_return(@context)
        end

        it "sends" do
          expect(@user.identify!).to be_nil
        end
      end
    end

    describe :update_user! do
      before do
        @request_params = {
          id: nil,
          email: "user@getvero.com",
          changes: {email: "user@getvero.com", age: 20, _user_type: "User"}
        }
        @url = "https://api.getvero.com/api/v2/users/edit.json"
      end

      it "should send an `update_user` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user

        allow(@user).to receive(:with_vero_context).and_return(context)

        allow(Vero::Api::Users).to receive(:edit_user!).and_return(200)
        expect(Vero::Api::Users).to receive(:edit_user!).with(@request_params, context)

        expect(@user.with_vero_context.update_user!).to eq(200)
      end

      context "when set to use async" do
        before do
          @context = vero_context(@user, false, true)
          allow(@user).to receive(:with_vero_context).and_return(@context)
        end

        it "sends" do
          expect(@user.with_vero_context.update_user!).to be_nil
        end
      end
    end

    describe :update_user_tags! do
      before do
        @request_params = {
          id: nil,
          email: "user@getvero.com",
          add: [],
          remove: []
        }
        @url = "https://api.getvero.com/api/v2/users/tags/edit.json"
      end

      it "should send an `update_user_tags` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = false

        allow(@user).to receive(:with_vero_context).and_return(context)

        allow(Vero::Api::Users).to receive(:edit_user_tags!).and_return(200)
        expect(Vero::Api::Users).to receive(:edit_user_tags!).with(@request_params, context)

        expect(@user.with_vero_context.update_user_tags!).to eq(200)
      end

      it "should send using another thread when async is set to true" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = true

        allow(@user).to receive(:with_vero_context).and_return(context)

        expect(@user.with_vero_context.update_user_tags!).to be_nil
      end
    end

    describe :unsubscribe! do
      before do
        @request_params = {
          id: nil,
          email: "user@getvero.com"
        }
        @url = "https://api.getvero.com/api/v2/users/unsubscribe.json"
      end

      it "should send an `update_user` request when async is set to false" do
        context = Vero::Context.new(Vero::App.default_context)
        context.subject = @user
        context.config.async = false

        allow(@user).to receive(:with_vero_context).and_return(context)

        allow(Vero::Api::Users).to receive(:unsubscribe!).and_return(200)
        expect(Vero::Api::Users).to receive(:unsubscribe!).with(@request_params, context)

        expect(@user.with_vero_context.unsubscribe!).to eq(200)
      end

      context "when using async" do
        before do
          @context = vero_context(@user, false, true)
          allow(@user).to receive(:with_vero_context).and_return(@context)
        end

        it "sends" do
          expect(@user.with_vero_context.unsubscribe!).to be_nil
        end
      end
    end

    describe :trackable do
      before { User.reset_trackable_map! }

      it "builds an array of trackable params" do
        User.trackable :email, :age
        expect(User.trackable_map).to eq(%i[email age])
      end

      it "appends new trackable items to an existing trackable map" do
        User.trackable :email, :age
        User.trackable :hair_colour
        expect(User.trackable_map).to eq(%i[email age hair_colour])
      end

      it "appends an extra's hash to the trackable map" do
        User.trackable :email, {extras: :properties}
        expect(User.trackable_map).to eq([:email, {extras: :properties}])
      end
    end

    describe :to_vero do
      before :all do
        User.reset_trackable_map!
        User.trackable :email, :age
      end

      it "returns a hash of all values mapped by trackable" do
        user = User.new
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 20, _user_type: "User"})

        user = UserWithoutEmail.new
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 20, _user_type: "UserWithoutEmail"})

        user = UserWithEmailAddress.new
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 20, _user_type: "UserWithEmailAddress"})

        user = UserWithoutInterface.new
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 20, _user_type: "UserWithoutInterface"})

        user = UserWithNilAttributes.new
        expect(user.to_vero).to eq({email: "user@getvero.com", _user_type: "UserWithNilAttributes"})
      end

      it "takes into account any defined extras" do
        user = UserWithExtras.new
        user.properties = nil
        expect(user.to_vero).to eq({email: "user@getvero.com", _user_type: "UserWithExtras"})

        user.properties = "test"
        expect(user.to_vero).to eq({email: "user@getvero.com", _user_type: "UserWithExtras"})

        user.properties = {}
        expect(user.to_vero).to eq({email: "user@getvero.com", _user_type: "UserWithExtras"})

        user.properties = {
          age: 20,
          gender: "female"
        }
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 20, gender: "female", _user_type: "UserWithExtras"})

        user = UserWithPrivateExtras.new
        expect(user.to_vero).to eq({email: "user@getvero.com", age: 26, _user_type: "UserWithPrivateExtras"})
      end

      it "should allow extras to be provided instead :id or :email" do
        user = UserWithOnlyExtras.new
        user.properties = {email: user.email}
        expect(user.to_vero).to eq({email: "user@getvero.com", _user_type: "UserWithOnlyExtras"})
      end
    end

    describe :with_vero_context do
      it "can change contexts" do
        user = User.new
        expect(user.with_default_vero_context.config.config_params).to eq({tracking_api_key: "YWJjZDEyMzQ6ZWZnaDU2Nzg="})
        expect(user.with_vero_context({tracking_api_key: "boom"}).config.config_params).to eq({tracking_api_key: "boom"})
      end
    end

    it "should work when Vero::Trackable::Interface is not included" do
      user = UserWithoutInterface.new

      request_params = {
        event_name: "test_event",
        tracking_api_key: "YWJjZDEyMzQ6ZWZnaDU2Nzg=",
        identity: {email: "user@getvero.com", age: 20, _user_type: "UserWithoutInterface"},
        data: {test: 1},
        extras: {}
      }

      context = Vero::Context.new(Vero::App.default_context)
      context.subject = user
      allow(context).to receive(:post_now).and_return(200)
      allow(user).to receive(:with_vero_context).and_return(context)

      stub_request(:post, "https://api.getvero.com/api/v2/events/track.json")
        .with(body: request_params, headers: {content_type: "application/json"})
        .to_return(status: 200)

      resp = user.vero_track(request_params[:event_name], request_params[:data])
      expect(resp.code).to eq(200)
    end
  end
end
