# frozen_string_literal: true

require "rspec"
require "sidekiq"
require "sidekiq/web"

require "sidekiq/enqueue"

# Require all support files
Dir[File.join(File.expand_path("support", __dir__), "**/*.rb")].each { |file_name| require_relative file_name }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
