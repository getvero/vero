# frozen_string_literal: true

require "spec_helper"

describe Vero::DSL::Proxy do
  subject(:proxy) { described_class.new }

  describe "#users" do
    it "is a pointer to Vero::Api::Users" do
      expect(proxy.users).to eql(Vero::Api::Users)
    end

    it "responds to reidentify!" do
      expect(proxy.users.respond_to?(:reidentify!)).to be(true)
    end
  end

  describe "#events" do
    it "is a pointer to Vero::Api::Events" do
      expect(proxy.events).to eql(Vero::Api::Events)
    end
  end
end
