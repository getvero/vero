# frozen_string_literal: true

require 'spec_helper'

describe Vero::Api::Workers::Users::TrackAPI do
  let(:payload) do
    {
      auth_token: 'abcd',
      identity: { email: 'test@test.com' },
      email: 'test@test.com'
    }
  end

  subject { Vero::Api::Workers::Users::TrackAPI.new('https://api.getvero.com', payload) }

  it_behaves_like 'a Vero wrapper' do
    let(:end_point) { '/api/v2/users/track.json' }
  end

  describe :validate! do
    it 'should raise an error if email and id are are blank String' do
      subject.options = payload
      expect { subject.send(:validate!) }.to_not raise_error

      payload.delete(:email)
      subject.options = payload
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      subject.options = payload.merge(id: '')
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      subject.options = payload.merge(id: 'user123')
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it 'should raise an error if data is not either nil or a Hash' do
      subject.options = payload.merge(data: [])
      expect { subject.send(:validate!) }.to raise_error(ArgumentError)

      subject.options = payload.merge(data: nil)
      expect { subject.send(:validate!) }.to_not raise_error

      subject.options = payload.merge(data: {})
      expect { subject.send(:validate!) }.to_not raise_error
    end

    it 'should not raise an error when the keys are Strings' do
      options = { 'auth_token' => 'abcd', 'identity' => { 'email' => 'test@test.com' }, 'email' => 'test@test.com', 'data' => {} }
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end
  end

  describe :request do
    it 'should send a request to the Vero API' do
      expect(RestClient::Request).to(
        receive(:execute).with(
          method: :post,
          url: 'https://api.getvero.com/api/v2/users/track.json',
          payload: { auth_token: 'abcd', identity: { email: 'test@test.com' }, email: 'test@test.com' }.to_json,
          headers: { content_type: :json, accept: :json },
          timeout: 60
        )
      )
      allow(RestClient::Request).to receive(:execute).and_return(200)
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
