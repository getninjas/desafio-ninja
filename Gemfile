source 'https://rubygems.org'
git_source(:github) { |_repo| 'https://github.com/#{repo}.git' }

ruby '3.0.0'
gem 'active_model_serializers', '0.10.13'
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'ffaker',                     '2.13.0'
  gem 'rspec_junit_formatter',      '0.4.1'
  gem 'rspec-rails',                '3.8.2'
  gem 'rubocop',                    '~> 0.77.0', require: false
  gem 'rubocop-rails',              '~> 2.4.0', require: false
  gem 'rubocop-rspec',              '~> 1.37.1', require: false
end

group :development do
end

group :test do
  gem 'pundit-matchers',            '1.6.0'
  gem 'rails-controller-testing',   '1.0.4'
  gem 'shoulda-matchers',           '4.1.2'
  gem 'simplecov',                  '0.17.1', require: false
  gem 'timecop',                    '0.9.1'
  gem 'vcr',                        '5.1.0'
  gem 'webmock',                    '3.8.2'
end
