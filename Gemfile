ruby '3.1.1'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'action_policy'
gem 'bcrypt'
gem 'bootsnap', require: false
gem 'bugsnag', '~> 6.24'
gem 'cssbundling-rails'
gem 'haml-rails'
gem 'hotwire-rails'
gem 'jsbundling-rails'
gem 'pagy'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'redis', '~> 4.0'
gem 'sprockets-rails', '>= 2.0.0'
gem 'stimulus-rails', '>= 0.4.0'
gem 'turbo-rails', '>= 0.7.11'
gem 'view_component'

group :development, :test do
  gem 'debug'
  gem 'i18n-tasks', require: false, git: 'https://github.com/glebm/i18n-tasks.git', branch: 'main'
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
