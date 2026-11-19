# Load @custom backend code into the Rails application.
# Adds server/src/ paths to the autoloader and loads @custom routes.

Rails.application.config.to_prepare do
  # Add @custom paths to autoload paths so Rails can find controllers and models
  custom_paths = [
    Rails.root.join("server", "src", "api", "@custom"),
    Rails.root.join("server", "src", "models", "@custom")
  ]

  custom_paths.each do |path|
    ActiveSupport::Dependencies.autoload_paths << path.to_s unless ActiveSupport::Dependencies.autoload_paths.include?(path.to_s)
  end
end

# Add @custom migration path so Rails can find and run the migration
Rails.application.config.paths["db/migrate"] << Rails.root.join("server", "db", "migrate", "@custom").to_s

# Load @custom routes
custom_routes_file = Rails.root.join("server", "src", "api", "@custom", "routes.rb")
require custom_routes_file if File.exist?(custom_routes_file)