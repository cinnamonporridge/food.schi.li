ruby '2.6.5'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'draper', '>= 3.0.0'
gem 'font-awesome-rails'
gem 'foundation-datepicker-rails'
gem 'foundation-rails'
gem 'haml'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.0.0'
gem 'sass-rails', '~> 6.0'
gem 'sassc', git: 'https://github.com/sass/sassc-ruby.git', ref: '1bc1c545f38a1888103e0b4b050d3ad50d77ef9d'
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
