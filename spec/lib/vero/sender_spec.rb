# frozen_string_literal: true

require "spec_helper"

describe Vero::Sender do
  describe ".senders" do
    it "automatically finds senders that are not defined" do
      expect(described_class.senders[:delayed_job]).to eq(Vero::Senders::DelayedJob)
      expect(described_class.senders[:sucker_punch]).to eq(Vero::Senders::SuckerPunch)
      expect(described_class.senders[:resque]).to eq(Vero::Senders::Resque)
      expect(described_class.senders[:sidekiq]).to eq(Vero::Senders::Sidekiq)
      expect(described_class.senders[:invalid]).to eq(Vero::Senders::Invalid)
      expect(described_class.senders[:none]).to eq(Vero::Senders::Base)
    end

    it "falls back to Vero::Senders::Base" do
      expect(described_class.senders[:unsupported_sender]).to eq(Vero::Senders::Base)
    end
  end
end
