# frozen_string_literal: true

require 'spec_helper'

describe Vero::Api::Workers::Users::EditTagsAPI do
  let(:payload) do
    {
      auth_token: 'abcd',
      id: 'test@test.com',
      add: ['test']
    }
  end

  subject { Vero::Api::Workers::Users::EditTagsAPI.new('https://api.getvero.com', payload) }

  it_behaves_like 'a Vero wrapper' do
    let(:end_point) { '/api/v2/users/tags/edit.json' }
  end

  describe :validate! do
    it 'should raise an error if email is a blank String' do
      subject.options = payload.merge(id: nil, add: [])
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      subject.options = payload.merge(add: [])
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it 'should raise an error if add is not an Array or missing' do
      subject.options = payload.merge(add: 'foo')
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it 'should raise an error if remove is not an Array or missing' do
      subject.options = payload.merge(remove: 'foo')
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it 'should raise an error if botha add and remove are missing' do
      payload.delete(:add)
      subject.options = payload
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)
    end

    it 'should not raise an error if the correct arguments are passed' do
      payload.delete(:add)
      subject.options = payload.merge(remove: ['Hi'])
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it 'should not raise an error when the keys are Strings' do
      subject.options = { 'auth_token' => 'abcd', 'id' => 'test@test.com', 'remove' => ['Hi'] }
      expect { subject.send(:validate!) }.to_not raise_error
    end
  end

  describe :request do
    it 'should send a request to the Vero API' do
      expect(RestClient::Request).to(
        receive(:execute).with(
          method: :put,
          url: 'https://api.getvero.com/api/v2/users/tags/edit.json',
          payload: { auth_token: 'abcd', id: 'test@test.com', add: ['test'] }.to_json,
          headers: { content_type: :json, accept: :json },
          timeout: 60
        )
      )
      allow(RestClient).to receive(:put).and_return(200)
      subject.send(:request)
    end
  end

  describe 'integration test' do
    it 'should not raise any errors' do
      allow(RestClient::Request).to receive(:execute).and_return(200)
      expect { subject.perform }.to_not raise_error
    end
  end
end
