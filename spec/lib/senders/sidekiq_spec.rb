# frozen_string_literal: true

require "spec_helper"

describe Vero::Senders::Sidekiq do
  subject { Vero::Senders::Sidekiq.new }
  describe :call do
    it "should perform_async a Vero::SidekiqWorker" do
      expect(Vero::SidekiqWorker).to(
        receive(:perform_async)
        .with("Vero::Api::Workers::Events::TrackAPI", "abc", {test: "abc"})
        .once
      )
      subject.call(Vero::Api::Workers::Events::TrackAPI, "abc", {test: "abc"})
    end
  end
end

describe Vero::SidekiqWorker do
  subject { Vero::SidekiqWorker.new }
  describe :perform do
    it "should call the api method" do
      mock_api = double(Vero::Api::Workers::Events::TrackAPI)
      expect(mock_api).to receive(:perform).once

      allow(Vero::Api::Workers::Events::TrackAPI).to receive(:new).and_return(mock_api)
      expect(Vero::Api::Workers::Events::TrackAPI).to receive(:new).with("abc", {test: "abc"}).once

      subject.perform("Vero::Api::Workers::Events::TrackAPI", "abc", {test: "abc"})
    end
  end
end
