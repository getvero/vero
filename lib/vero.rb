# frozen_string_literal: true

require "base64"
require "json"
require "rest-client"
require "zeitwerk"

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
loader.setup

require "vero/railtie" if defined?(Rails)
