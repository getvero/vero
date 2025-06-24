# frozen_string_literal: true

require "base64"
require "json"
require "rest-client"
require "zeitwerk"

module Vero
end

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "api_context" => "APIContext",
  "dsl" => "DSL",
  "base_api" => "BaseAPI",
  "track_api" => "TrackAPI",
  "delete_api" => "DeleteAPI",
  "edit_api" => "EditAPI",
  "edit_tags_api" => "EditTagsAPI",
  "reidentify_api" => "ReidentifyAPI",
  "resubscribe_api" => "ResubscribeAPI",
  "unsubscribe_api" => "UnsubscribeAPI"
)
loader.ignore("#{__dir__}/generators")

loader.push_dir("#{__dir__}/vero/workers", namespace: Vero)
loader.ignore("#{__dir__}/vero/workers/resque_worker") unless defined?(Resque)
loader.ignore("#{__dir__}/vero/workers/sidekiq_worker") unless defined?(::Sidekiq)
loader.ignore("#{__dir__}/vero/workers/sucker_punch_worker") unless defined?(SuckerPunch)

loader.setup

require "vero/railtie" if defined?(Rails)
