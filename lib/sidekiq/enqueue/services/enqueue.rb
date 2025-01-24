# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Services
      class Enqueue
        def initialize(job_name, arguments)
          @job_class = Module.const_get(job_name)
          @arguments = arguments
        end

        def call
          @job_class.perform_async(*@arguments.split(",").map(&:strip))
        end
      end
    end
  end
end
