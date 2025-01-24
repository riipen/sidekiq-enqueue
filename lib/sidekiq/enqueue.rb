# frozen_string_literal: true

require "sidekiq"
require "sidekiq/web"

require_relative "enqueue/web"

module Sidekiq
  module Enqueue
    def self.init
      Sidekiq::Web.register(Sidekiq::Enqueue::Web)
      Sidekiq::Web.tabs["Enqueue"] = "enqueue"
      Sidekiq::Web.locales << File.expand_path("enqueue/web/locales", __dir__)
    end
  end
end
