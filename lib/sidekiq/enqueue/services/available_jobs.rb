# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Services
      class AvailableJobs
        def self.call
          eager_load_jobs!

          ObjectSpace.each_object(Class)
                     .filter_map { |klass| job_name_for(klass) }
                     .uniq
                     .sort
        end

        def self.eager_load_jobs!
          return unless defined?(Rails) && Rails.respond_to?(:root) && Rails.root

          Dir[Rails.root.join("app/jobs/**/*.rb")].sort.each do |file|
            if defined?(require_dependency)
              require_dependency(file)
            else
              require(file)
            end
          rescue StandardError => e
            Sidekiq.logger.warn("sidekiq-enqueue: unable to load job file #{file}: #{e.class}: #{e.message}")
          end
        rescue StandardError => e
          Sidekiq.logger.warn("sidekiq-enqueue: unable to load app/jobs: #{e.class}: #{e.message}")
        end

        def self.job_name_for(klass)
          return unless klass.name
          return unless valid_job_class?(klass)

          klass.name
        rescue StandardError
          nil
        end

        def self.valid_job_class?(klass)
          klass.respond_to?(:perform_async) && klass.respond_to?(:get_sidekiq_options)
        end

        private_class_method :eager_load_jobs!, :job_name_for, :valid_job_class?, :new
      end
    end
  end
end
