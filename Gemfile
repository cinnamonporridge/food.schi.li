ruby '3.1.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'haml-rails'
gem 'hotwire-rails'
gem 'jsbundling-rails'
# Ruby 3.1 removed net/* from default gems, mail gem depends on it
gem 'net-imap'
gem 'net-pop'
gem 'net-smtp'
gem 'pagy'
gem 'pg'
gem 'puma'
gem 'rails', git: 'https://github.com/rails/rails.git', branch: '7-0-stable'
gem 'redis', '~> 4.0'
gem 'simple_form'
gem 'sprockets-rails', '>= 2.0.0'
gem 'stimulus-rails', '>= 0.4.0'
gem 'turbo-rails', '>= 0.7.11'

group :development, :test do
  gem 'debug'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake'
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
