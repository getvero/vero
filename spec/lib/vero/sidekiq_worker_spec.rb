# frozen_string_literal: true

require "spec_helper"

describe Vero::SidekiqWorker do
  subject(:worker) { described_class.new }

  describe "#perform" do
    it "calls the api method" do
      mock_api = instance_double(Vero::Api::Workers::Events::TrackAPI)
      expect(mock_api).to receive(:perform).once

      expect(Vero::Api::Workers::Events::TrackAPI).to receive(:new)
        .with("abc", {test: "abc"})
        .once
        .and_return(mock_api)

      worker.perform("Vero::Api::Workers::Events::TrackAPI", "abc", {test: "abc"})
    end
  end
end
