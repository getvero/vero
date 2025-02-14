# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::ResubscribeAPI do
  subject { Vero::Api::Workers::Users::ResubscribeAPI.new("https://api.getvero.com", {auth_token: "abcd", id: "1234"}) }

  it_behaves_like "a Vero wrapper" do
    let(:end_point) { "/api/v2/users/resubscribe.json" }
  end

  describe :validate! do
    it "should not raise an error when the keys are Strings" do
      subject.options = {"auth_token" => "abcd", "id" => "1234"}
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it "should raise an error for missing keys" do
      subject.options = {"auth_token" => "abcd"}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end
  end

  describe :request do
    it "should send a request to the Vero API" do
      expect(RestClient).to(
        receive(:post)
        .with("https://api.getvero.com/api/v2/users/resubscribe.json", {auth_token: "abcd", id: "1234"})
      )
      allow(RestClient).to receive(:post).and_return(200)

      subject.send(:request)
    end
  end
end
