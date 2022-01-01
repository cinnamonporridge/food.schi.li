ruby '3.1.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'draper', '>= 3.0.0'
gem 'haml'
gem 'kaminari'
# Ruby 3.1 removed net/* from default gems, mail gem depends on it
gem 'net-imap'
gem 'net-pop'
gem 'net-smtp'
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.1'
gem 'sass-rails'
gem 'simple_form'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'listen'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

group :production do
  gem 'uglifier', '>= 1.3.0'
end
