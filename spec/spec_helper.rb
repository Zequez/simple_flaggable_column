require 'simple_flaggable_column'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Default in RSpec 4
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Default in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end
