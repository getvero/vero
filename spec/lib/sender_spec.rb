# frozen_string_literal: true

require "spec_helper"

describe Vero::Sender do
  subject { Vero::Sender }

  describe ".senders" do
    it "should automatically find senders that are not defined" do
      expect(subject.senders[:delayed_job]).to eq(Vero::Senders::DelayedJob)
      expect(subject.senders[:sucker_punch]).to eq(Vero::Senders::SuckerPunch)
      expect(subject.senders[:resque]).to eq(Vero::Senders::Resque)
      expect(subject.senders[:sidekiq]).to eq(Vero::Senders::Sidekiq)
      expect(subject.senders[:invalid]).to eq(Vero::Senders::Invalid)
      expect(subject.senders[:none]).to eq(Vero::Senders::Base)
    end

    it "should fallback to Vero::Senders::Base" do
      expect(subject.senders[:unsupported_sender]).to eq(Vero::Senders::Base)
    end
  end
end
