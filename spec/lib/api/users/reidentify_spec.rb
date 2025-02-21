# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::ReidentifyAPI do
  let(:payload) { {auth_token: "abcd", id: "test@test.com", new_id: "test2@test.com"} }

  subject { Vero::Api::Workers::Users::ReidentifyAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :put }
    let(:endpoint) { "/api/v2/users/reidentify.json" }
  end

  describe :validate! do
    it "raises an error if id is missing" do
      subject.options = {auth_token: "abcd", new_id: "test2@test.com"}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "raises an error if new_id is missing" do
      subject.options = {auth_token: "abcd", id: "test@test.com"}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      stub_request(:put, "https://api.getvero.com/api/v2/users/reidentify.json")
        .to_return(status: 200)

      expect { subject.perform }.to_not raise_error
    end
  end
end
