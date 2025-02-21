# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::ResubscribeAPI do
  let(:payload) { {auth_token: "abcd", id: "1234"} }

  subject { Vero::Api::Workers::Users::ResubscribeAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/resubscribe.json" }
  end

  describe :validate! do
    it "should raise an error for missing keys" do
      subject.options = {"auth_token" => "abcd"}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end
  end
end
