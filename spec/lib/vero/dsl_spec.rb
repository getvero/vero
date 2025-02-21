# frozen_string_literal: true

require "spec_helper"

describe Vero::DSL do
  subject(:dsl) { Class.new.extend(described_class) }

  describe "#vero" do
    it "is a proxy to the API" do
      expect(dsl.vero).to be_an_instance_of(Vero::DSL::Proxy)
    end
  end
end
