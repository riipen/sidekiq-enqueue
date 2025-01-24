# frozen_string_literal: true

require "sidekiq"

module Sidekiq
  module Enqueue
    class DummyJob
      include Sidekiq::Worker

      def perform; end
    end
  end
end
