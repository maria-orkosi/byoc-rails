# Analytics configuration.
# The tracking key is set via the ANALYTICS_KEY environment variable.
# The analytics endpoint is set via the ANALYTICS_ENDPOINT environment variable.
# Analytics only load in production unless ANALYTICS_FORCE_ENABLE is set.
Rails.application.config.analytics_key      = ENV["ANALYTICS_KEY"]
Rails.application.config.analytics_endpoint = ENV["ANALYTICS_ENDPOINT"]

Rails.application.config.analytics_enabled = if ENV["ANALYTICS_FORCE_ENABLE"].present?
  ActiveModel::Type::Boolean.new.cast(ENV["ANALYTICS_FORCE_ENABLE"])
else
  Rails.env.production?
end