# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::TrackAPI do
  subject(:api) { described_class.new("https://api.getvero.com", payload) }

  let(:payload) { {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com"} }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/track.json" }
  end

  describe "#validate!" do
    it "raises an error if email and id are are blank String" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: nil, email: nil}
      api.options = options
      expect { api.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: nil, email: "test@test.com"}
      api.options = options
      expect { api.send(:validate!) }.not_to raise_error

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: "", email: nil}
      api.options = options
      expect { api.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: "user123", email: nil}
      api.options = options
      expect { api.send(:validate!) }.not_to raise_error
    end

    it "raises an error if data is not either nil or a Hash" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: []}
      api.options = options
      expect { api.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: nil}
      api.options = options
      expect { api.send(:validate!) }.not_to raise_error

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: {}}
      api.options = options
      expect { api.send(:validate!) }.not_to raise_error
    end
  end

  describe "integration test" do
    it "does not raise any errors" do
      stub_request(:post, "https://api.getvero.com/api/v2/users/track.json")
        .to_return(status: 200)

      expect { api.perform }.not_to raise_error
    end
  end
end
