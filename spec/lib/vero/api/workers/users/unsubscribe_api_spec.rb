# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::UnsubscribeAPI do
  subject(:api) { described_class.new("https://api.getvero.com", payload) }

  let(:payload) { {auth_token: "abcd", email: "test@test.com", changes: {email: "test@test.com"}} }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/unsubscribe.json" }
  end

  describe "integration test" do
    it "does not raise any errors" do
      stub_request(:post, "https://api.getvero.com/api/v2/users/unsubscribe.json")
        .to_return(status: 200)

      expect { api.perform }.not_to raise_error
    end
  end
end
