# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# Manage scheduled tasks
gem 'whenever', :require => false
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', :require => false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', :platforms => %i[mri mingw x64_mingw]

  # Debugger
  gem 'debase', '~> 0.2.1'

  # Enforce code style using Rubocop
  gem 'rubocop', :require => false

  # Check for vulnerable versions of gems
  gem 'bundler-audit', :require => false

  # Detect code smells
  gem 'reek', :require => false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Git pre-commit hooks
  gem 'overcommit', :require => false

  # Analyze potential speed improvements
  gem 'fasterer', :require => false

  # Security vulnerability scanner
  gem 'brakeman', :require => false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => %i[mingw mswin x64_mingw jruby]
