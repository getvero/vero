# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::EditAPI do
  let(:payload) { {auth_token: "abcd", email: "test@test.com", changes: {email: "test@test.com"}} }

  subject { Vero::Api::Workers::Users::EditAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :put }
    let(:endpoint) { "/api/v2/users/edit.json" }
  end

  describe "integration test" do
    it "should not raise any errors" do
      stub_request(:put, "https://api.getvero.com/api/v2/users/edit.json")
        .to_return(status: 200)

      expect { subject.perform }.to_not raise_error
    end
  end
end
