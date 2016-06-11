# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'bundler/setup'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda/matchers'

include Warden::Test::Helpers
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.around(:each, type: :view) do |ex|
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = false
      ex.run
      mocks.verify_partial_doubles = true
    end
  end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.run_all_when_everything_filtered = true
  config.infer_spec_type_from_file_location!
  config.order = 'random'
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  #>>>>>COLOR
  config.failure_color = :red
  config.tty = true
  config.color = true
  #<<<<<

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.expose_current_running_example_as :example

  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  DatabaseCleaner.orm = :mongoid
  config.include Mongoid::Matchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    Dir.foreach('./app/models/') do |file|
      if file =~ /^(.*)\.rb$/
        model = $1.split('_').map(&:capitalize).join
        Object.const_get(model).delete_all
      end
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end