# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Events do
  let(:api) { described_class }
  let(:mock_context) { Vero::Context.new }

  let(:input) { {event_name: "test_event", identity: {email: "james@getvero.com"}, data: {test: "test"}} }
  let(:expected) { input.merge(tracking_api_key: "abc123", _config: {http_timeout: 60}) }

  before do
    allow(mock_context.config).to receive_messages(configured?: true, tracking_api_key: "abc123")
    allow(Vero::App).to receive(:default_context).and_return(mock_context)
  end

  it "passes http_timeout to API requests" do
    allow(mock_context.config).to receive(:http_timeout).and_return(30)

    expect(Vero::Sender).to(
      receive(:call).with(
        Vero::Api::Workers::Events::TrackAPI, true, "https://api.getvero.com", expected.merge(_config: {http_timeout: 30})
      )
    )
    api.track!(input)
  end

  describe ".track!" do
    context "when calling via the configured sender" do
      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Events::TrackAPI, true, "https://api.getvero.com", expected)
        api.track!(input)
      end
    end
  end
end
