# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::ResubscribeAPI do
  subject(:api) { described_class.new("https://api.getvero.com", payload) }

  let(:payload) { {auth_token: "abcd", id: "1234"} }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/resubscribe.json" }
  end

  describe "#validate!" do
    it "raises an error for missing keys" do
      api.options = {"auth_token" => "abcd"}
      expect { api.send(:validate!) }.to raise_error(ArgumentError)
    end
  end
end
