# frozen_string_literal: true

require "spec_helper"

describe Vero::Senders::Sidekiq do
  subject { Vero::Senders::Sidekiq.new }

  let(:domain) { "https://api.getvero.com" }
  let(:payload) { {event_name: "test"} }

  describe "call" do
    it "should perform_async a Vero::SidekiqWorker" do
      expect(Vero::SidekiqWorker).to(
        receive(:perform_async)
        .with("Vero::Api::Workers::Events::TrackAPI", domain, payload.transform_keys(&:to_s))
        .and_call_original
        .once
      )

      subject.call(Vero::Api::Workers::Events::TrackAPI, domain, payload)
    end

    context "transforming options" do
      it "transforms the payload to be JSON-safe" do
        payload[:data] = {
          items: [{item: :sku_1234, price: 50}, {item: :sku_5678, price: 50}],
          total: 100.00
        }

        expected_payload = {
          "event_name" => "test",
          "data" => {
            "items" => [
              {"item" => "sku_1234", "price" => 50},
              {"item" => "sku_5678", "price" => 50}
            ],
            "total" => 100.00
          }
        }

        expect(Vero::SidekiqWorker).to receive(:perform_async)
          .with("Vero::Api::Workers::Events::TrackAPI", domain, expected_payload)
          .and_call_original
          .once

        subject.enqueue_work(Vero::Api::Workers::Events::TrackAPI, domain, payload)
      end

      it "handles times, sets, nested symbols" do
        timestamp = Time.utc(2025, 1, 1, 12, 0, 0)
        custom_payload = {
          event_name: :test_event,
          occurred_at: timestamp,
          metadata: {
            tags: Set.new([:premium, :new_user]),
            nested: {level: :deep}
          },
          some_array: [:alpha, :beta, 123]
        }

        # Expected structure after transformation:
        expected_payload = {
          "event_name" => "test_event",
          "occurred_at" => timestamp.iso8601, # "2025-01-01T12:00:00Z"
          "metadata" => {
            "tags" => ["premium", "new_user"],
            "nested" => {"level" => "deep"}
          },
          "some_array" => ["alpha", "beta", 123]
        }

        expect(Vero::SidekiqWorker).to receive(:perform_async).with(
          "Vero::Api::Workers::Events::TrackAPI",
          domain,
          expected_payload
        ).and_call_original.once

        subject.enqueue_work(Vero::Api::Workers::Events::TrackAPI, domain, custom_payload)
      end
    end
  end
end

describe Vero::SidekiqWorker do
  let(:domain) { "https://api.getvero.com" }
  let(:payload) { {"event_name" => "test"} }

  subject { Vero::SidekiqWorker.new }
  describe "perform" do
    it "should call the api method" do
      expect(Vero::Api::Workers::Events::TrackAPI).to(
        receive(:perform)
          .with(domain, payload)
          .once
      )

      subject.perform("Vero::Api::Workers::Events::TrackAPI", domain, payload)
    end
  end
end
