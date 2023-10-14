source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "action_policy"
gem "bcrypt"
gem "bootsnap", require: false
gem "bugsnag", "~> 6.24"
gem "haml-rails"
gem "importmap-rails"
gem "pagy"
gem "pg"
gem "puma"
gem "rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "view_component"

group :development, :test do
  gem "debug"
  gem "i18n-tasks", require: false, git: "https://github.com/glebm/i18n-tasks.git", branch: "main"
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
end

group :development do
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
