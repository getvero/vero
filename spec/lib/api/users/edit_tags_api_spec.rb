# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::EditTagsAPI do
  let(:payload) { {email: "test@test.com", add: ["test"]} }

  subject { Vero::Api::Workers::Users::EditTagsAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :put }
    let(:endpoint) { "/api/v2/users/tags/edit.json" }
  end

  describe :validate! do
    it "raises an error if email is a blank String" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: nil, add: []}
      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", add: []}
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it "raises an error if add is not an Array or missing" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", add: "foo"}

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "raises an error if remove is not an Array or missing" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", remove: "foo"}

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "raises an error if both add and remove are missing" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com"}

      subject.options = options
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it "does not raise an error if the correct arguments are passed" do
      options = {auth_token: "abcd", identity: {email: "test@test.com"}, email: "test@test.com", remove: ["Hi"]}

      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end
  end

  describe "integration test" do
    it "should not raise any errors" do
      stub_request(:put, "https://api.getvero.com/api/v2/users/tags/edit.json")
        .to_return(status: 200)
      expect { subject.perform }.to_not raise_error
    end
  end
end
