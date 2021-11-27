# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:each, truncation: true) do
    @cleaner_strategy = :truncation
  end

  config.before(:each) do |_group|
    @cleaner_strategy ||= :transaction

    DatabaseCleaner.strategy = @cleaner_strategy
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
