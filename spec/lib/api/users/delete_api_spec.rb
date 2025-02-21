# frozen_string_literal: true

require "spec_helper"

describe Vero::Api::Workers::Users::DeleteAPI do
  let(:payload) { {auth_token: "abcd", id: "1234"} }

  subject { Vero::Api::Workers::Users::DeleteAPI.new("https://api.getvero.com", payload) }

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/delete.json" }
  end

  it_behaves_like "a Vero wrapper" do
    let(:request_method) { :post }
    let(:endpoint) { "/api/v2/users/delete.json" }
  end

  describe :validate! do
    it "raises an error for missing keys" do
      subject.options = {"auth_token" => "abcd"}
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end
  end
end
