require 'spec_helper'

describe Vero::Senders::Sidekiq do
  subject { Vero::Senders::Sidekiq.new }
  describe :call do
    it "should perform_async a Vero::SidekiqWorker" do
      Vero::SidekiqWorker.should_receive(:perform_async).with(Vero::API::Events::TrackAPI, "abc", {:test => "abc"}).once
      subject.call(Vero::API::Events::TrackAPI, "abc", {:test => "abc"})
    end
  end
end

describe Vero::SidekiqWorker do
  subject { Vero::SidekiqWorker.new }
  describe :perform do
    it "should call the api method" do
      mock_api = mock(Vero::API::Events::TrackAPI)
      mock_api.should_receive(:perform).once
      Vero::API::Events::TrackAPI.stub(:new).and_return(mock_api)
      Vero::API::Events::TrackAPI.should_receive(:new).with("abc", {:test => "abc"}).once

      subject.perform(Vero::API::Events::TrackAPI, "abc", {:test => "abc"})
    end
  end
end