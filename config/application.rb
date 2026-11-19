require_relative "boot"

require "rails"
require "active_record/railtie"
require "active_job/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module Bookings
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.eager_load = ENV["RAILS_ENV"] == "production"
    config.enable_reloading = ENV["RAILS_ENV"] != "production"
    config.consider_all_requests_local = ENV["RAILS_ENV"] != "production"
    config.active_job.queue_adapter = ENV["SIDEKIQ_ENABLED"] == "1" ? :sidekiq : :async

    # Logs go to the process output: the host (a function or a machine) keeps them, the disk is read-only there.
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    config.log_level = :info

    # The host writes nothing under the app directory: caches and pids live in the one writable path.
    config.cache_store = :memory_store
    config.active_support.cache_format_version = 7.1
    config.paths["tmp"] = ENV.fetch("TMPDIR", "/tmp")
  end
end
