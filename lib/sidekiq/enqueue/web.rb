# frozen_string_literal: true

require "pathname"

ROUTE_PATH = File.expand_path("web/routes", __dir__)

require_relative "services/enqueue"

require_relative "web/routes/enqueue"
require_relative "web/routes/index"

module Sidekiq
  module Enqueue
    module Web
      VIEW_PATH = File.expand_path("web/templates", __dir__)

      def self.registered(app)
        Sidekiq::Enqueue::Web::Routes::Enqueue.register(app)
        Sidekiq::Enqueue::Web::Routes::Index.register(app)
      end
    end
  end
end
