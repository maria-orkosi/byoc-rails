# This file is copied to spec/ when you run 'rails generate rspec:install'
require_relative "../config/environment"
require "rspec/rails"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Enable controller specs
  config.infer_spec_type_from_file_location!

  # Include session and request helpers for controller specs
  config.include RSpec::Rails::ControllerExampleGroup, type: :controller

  # Setup fixtures path
  config.fixture_paths = [Rails.root.join("spec", "fixtures")]

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Include helper methods
  config.include ActionView::Helpers, type: :helper
end