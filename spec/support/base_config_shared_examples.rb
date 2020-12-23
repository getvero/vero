# frozen_string_literal: true

RSpec.shared_examples 'a Vero wrapper' do
  it 'should inherit from Vero::Api::Workers::BaseCaller' do
    expect(subject).to be_a(Vero::Api::Workers::BaseAPI)
  end

  it 'should map to current version of Vero API' do
    expect(subject.send(:url)).to eq("https://api.getvero.com#{end_point}")
  end
end
