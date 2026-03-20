# frozen_string_literal: true

require "sidekiq"

module Sidekiq
  module Enqueue
    class DummyJob
      include Sidekiq::Job

      def perform; end
    end
  end
end
