# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Events do
  let(:subject) { Vero::Api::Events }
  let(:mock_context) { Vero::Context.new }

  let(:input) { {event_name: "test_event", identity: {email: "james@getvero.com"}, data: {test: "test"}} }
  let(:expected) { input.merge(tracking_api_key: "abc123", _config: {http_timeout: 60}) }

  before do
    allow(mock_context.config).to receive(:configured?).and_return(true)
    allow(mock_context.config).to receive(:tracking_api_key).and_return("abc123")
    allow(Vero::App).to receive(:default_context).and_return(mock_context)
  end

  it "should pass http_timeout to API requests" do
    allow(mock_context.config).to receive(:http_timeout).and_return(30)

    expect(Vero::Sender).to(
      receive(:call).with(
        Vero::Api::Workers::Events::TrackAPI, true, "https://api.getvero.com", expected.merge(_config: {http_timeout: 30})
      )
    )
    subject.track!(input)
  end

  describe :track! do
    context "should call the TrackAPI object via the configured sender" do
      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Events::TrackAPI, true, "https://api.getvero.com", expected)
        subject.track!(input)
      end
    end
  end
end

describe Vero::Api::Users do
  let(:subject) { Vero::Api::Users }
  let(:mock_context) { Vero::Context.new }
  let(:expected) { input.merge(tracking_api_key: "abc123", _config: {http_timeout: 60}) }

  before do
    allow(mock_context.config).to receive(:configured?).and_return(true)
    allow(mock_context.config).to receive(:tracking_api_key).and_return("abc123")
    allow(Vero::App).to receive(:default_context).and_return(mock_context)
  end

  describe :track! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {email: "james@getvero.com", data: {age: 25}} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::TrackAPI, true, "https://api.getvero.com", expected)
        subject.track!(input)
      end
    end
  end

  describe :edit_user! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {email: "james@getvero.com", changes: {age: 25}} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::EditAPI, true, "https://api.getvero.com", expected)
        subject.edit_user!(input)
      end
    end
  end

  describe :edit_user_tags! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {add: ["boom"], remove: ["tish"]} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::EditTagsAPI, true, "https://api.getvero.com", expected)
        subject.edit_user_tags!(input)
      end
    end
  end

  describe :unsubscribe! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {email: "james@getvero"} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::UnsubscribeAPI, true, "https://api.getvero.com", expected)
        subject.unsubscribe!(input)
      end
    end
  end

  describe :resubscribe! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {email: "james@getvero"} }

      specify do
        expect(Vero::Sender).to(
          receive(:call)
          .with(Vero::Api::Workers::Users::ResubscribeAPI, true, "https://api.getvero.com", expected)
        )
        subject.resubscribe!(input)
      end
    end
  end
end
