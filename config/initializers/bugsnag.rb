Bugsnag.configure do |config|
  config.api_key = ENV.fetch('FOOD_SCHI_LI_BUGSNAG_API_KEY', nil)
  config.notify_release_stages = %w[production]
end
