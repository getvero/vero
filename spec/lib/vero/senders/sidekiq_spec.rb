# frozen_string_literal: true

require "spec_helper"

describe Vero::Senders::Sidekiq do
  subject(:sender) { described_class.new }

  describe "#call" do
    it "perform_asyncs a Vero::SidekiqWorker" do
      expect(Vero::SidekiqWorker).to(
        receive(:perform_async)
        .with("Vero::Api::Workers::Events::TrackAPI", "abc", {test: "abc"})
        .once
      )
      sender.call(Vero::Api::Workers::Events::TrackAPI, "abc", {test: "abc"})
    end
  end
end
