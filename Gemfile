ruby '2.6.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.0.0'
gem 'pg'
gem 'puma'
gem 'sass-rails', '~> 6.0'
gem 'jquery-rails'
# gem 'redis', '~> 3.0'
gem 'bcrypt'
gem 'bootsnap'

gem 'simple_form'
gem 'font-awesome-rails'

gem 'chartkick'
gem 'select2-rails'

gem 'foundation-rails'
gem 'foundation-datepicker-rails'
gem 'sprockets-es6' # https://github.com/zurb/foundation-rails/issues/273

gem 'haml'
gem 'draper', '>= 3.0.0'
gem 'kaminari'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'webdrivers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'uglifier', '>= 1.3.0'
end
