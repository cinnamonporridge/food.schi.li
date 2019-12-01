ruby '2.6.5'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'jquery-rails'
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.0.0'
gem 'sass-rails', '~> 6.0'
# gem 'redis', '~> 3.0'
gem 'bcrypt'
gem 'bootsnap'

gem 'font-awesome-rails'
gem 'simple_form'

gem 'foundation-datepicker-rails'
gem 'foundation-rails'

gem 'draper', '>= 3.0.0'
gem 'haml'
gem 'kaminari'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'webdrivers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'uglifier', '>= 1.3.0'
end
