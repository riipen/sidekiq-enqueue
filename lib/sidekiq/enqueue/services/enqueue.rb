# frozen_string_literal: true

require "json"

module Sidekiq
  module Enqueue
    module Services
      class Enqueue
        def initialize(job_name, arguments)
          @job_name = job_name
          @arguments = arguments
        end

        def call
          job_class.perform_async(*@arguments.split(",").map(&:strip))
        end

        private

        def job_class
          Module.const_get(@job_name)
        end
      end
    end
  end
end
