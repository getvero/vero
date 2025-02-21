# frozen_string_literal: true

RSpec.shared_examples "a Vero wrapper" do
  it "inherits from Vero::Api::Workers::BaseCaller" do
    expect(subject).to be_a(Vero::Api::Workers::BaseAPI)
  end

  it "maps to current version of Vero API" do
    expect(subject.send(:url)).to eq("https://api.getvero.com#{endpoint}")
  end

  describe "#validate!" do
    it "does not raise an error when the keys are Strings" do
      subject.options = payload.deep_stringify_keys
      expect { subject.send(:validate!) }.not_to raise_error
    end
  end

  describe "#request" do
    it "sends a request to the Vero API" do
      stub = stub_request(request_method, ["https://api.getvero.com", endpoint].join)
        .with(body: payload, headers: {content_type: "application/json"})
        .to_return(status: 200)

      subject.send(:request)

      expect(stub).to have_been_requested
    end
  end
end
