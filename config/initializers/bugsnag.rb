Bugsnag.configure do |config|
  config.api_key = ENV['FOOD_SCHI_LI_BUGSNAG_API_KEY']
  config.notify_release_stages = %w[production]
end
