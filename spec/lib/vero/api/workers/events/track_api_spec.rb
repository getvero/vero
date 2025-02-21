# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Events::TrackAPI do
  subject(:api) { described_class.new("https://api.getvero.com", payload) }

  let(:payload) do
    {auth_token: "abcd", identity: {email: "test@test.com"}, event_name: "test_event"}
  end

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/events/track.json" }
  end

  context "with a request with properties" do
    describe "#validate!" do
      it "raises an error if event_name is a blank String" do
        api.options = payload.except(:event_name)
        expect { api.send(:validate!) }.to raise_error(ArgumentError)

        api.options = payload
        expect { api.send(:validate!) }.not_to raise_error
      end

      it "raises an error if data is not either nil or a Hash" do
        api.options = payload.merge(data: [])
        expect { api.send(:validate!) }.to raise_error(ArgumentError)

        api.options = payload.merge(data: nil)
        expect { api.send(:validate!) }.not_to raise_error

        api.options = payload.merge(data: {})
        expect { api.send(:validate!) }.not_to raise_error
      end

      it "does not raise an error when keys are Strings for initialization" do
        payload.transform_keys!(&:to_s)

        expect do
          described_class.new("https://api.getvero.com", payload).send(:validate!)
        end.not_to raise_error
      end
    end
  end

  describe "integration test" do
    it "completes without raising errors" do
      obj = described_class.new("https://api.getvero.com", payload)

      stub_request(:post, "https://api.getvero.com/api/v2/events/track.json")
        .with(body: payload, headers: {content_type: "application/json"})
        .to_return(status: 200)

      expect { obj.perform }.not_to raise_error
    end
  end
end
