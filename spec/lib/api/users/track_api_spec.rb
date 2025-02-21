# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::TrackAPI do
  let(:payload) { {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com"} }

  subject { Vero::Api::Workers::Users::TrackAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/track.json" }
  end

  describe :validate! do
    it "should raise an error if email and id are are blank String" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: nil, email: nil}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: nil, email: "test@test.com"}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: "", email: nil}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, id: "user123", email: nil}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it "should raise an error if data is not either nil or a Hash" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: []}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: nil}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", data: {}}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      stub_request(:post, "https://api.getvero.com/api/v2/users/track.json")
        .to_return(status: 200)

      expect { subject.perform }.to_not raise_error
    end
  end
end
