# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Users do
  subject(:api) { described_class }

  let(:mock_context) { Vero::Context.new }
  let(:expected) { input.merge(tracking_api_key: "abc123", _config: {http_timeout: 60}) }

  before do
    allow(mock_context.config).to receive_messages(configured?: true, tracking_api_key: "abc123")
    allow(Vero::App).to receive(:default_context).and_return(mock_context)
  end

  describe ".track!" do
    context "when calling via a configured sender" do
      let(:input) { {email: "james@getvero.com", data: {age: 25}} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::TrackAPI, true, "https://api.getvero.com", expected)
        api.track!(input)
      end
    end
  end

  describe ".edit_user!" do
    context "when calling via a configured sender" do
      let(:input) { {email: "james@getvero.com", changes: {age: 25}} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::EditAPI, true, "https://api.getvero.com", expected)
        api.edit_user!(input)
      end
    end
  end

  describe ".edit_user_tags!" do
    context "when calling via a configured sender" do
      let(:input) { {add: ["boom"], remove: ["tish"]} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::EditTagsAPI, true, "https://api.getvero.com", expected)
        api.edit_user_tags!(input)
      end
    end
  end

  describe ".unsubscribe!" do
    context "when calling via a configured sender" do
      let(:input) { {email: "james@getvero"} }

      specify do
        expect(Vero::Sender).to receive(:call).with(Vero::Api::Workers::Users::UnsubscribeAPI, true, "https://api.getvero.com", expected)
        api.unsubscribe!(input)
      end
    end
  end

  describe ".resubscribe!" do
    context "when calling via a configured sender" do
      let(:input) { {email: "james@getvero"} }

      specify do
        expect(Vero::Sender).to(
          receive(:call)
          .with(Vero::Api::Workers::Users::ResubscribeAPI, true, "https://api.getvero.com", expected)
        )
        api.resubscribe!(input)
      end
    end
  end
end
