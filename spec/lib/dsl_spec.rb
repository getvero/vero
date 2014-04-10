require 'spec_helper'

describe Vero::DSL do
  subject(:dsl) { Class.new.extend(Vero::DSL) }

  describe '#vero' do
    it 'is a proxy to the API' do
      expect(dsl.vero).to be_an_instance_of(Vero::DSL::Proxy)
    end
  end
end

describe Vero::DSL::Proxy do
  subject(:proxy) { described_class.new }

  describe '#users' do
    it 'is a pointer to Vero::Api::Users' do
      expect(proxy.users).to eql(Vero::Api::Users)
    end

    it "should respond to reidentify!" do
      expect(proxy.users.respond_to?(:reidentify!)).to be_true
    end
  end

  describe '#events' do
    it 'is a pointer to Vero::Api::Events' do
      expect(proxy.events).to eql(Vero::Api::Events)
    end
  end
end
