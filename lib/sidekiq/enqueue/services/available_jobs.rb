# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Services
      class AvailableJobs
        def self.call
          eager_load_jobs!

          job_names
        end

        def self.job_names
          @job_names ||= ObjectSpace.each_object(Class)
                                    .filter_map { |klass| job_name_for(klass) }
                                    .uniq
                                    .sort
        end

        def self.reset_cache!
          @job_names = nil
          @job_files = nil
        end

        def self.eager_load_jobs!
          return unless defined?(Rails) && Rails.respond_to?(:root) && Rails.root

          job_files
        end

        def self.job_files
          @job_files ||= Dir[Rails.root.join("app/jobs/**/*.rb")].each do |file|
            if defined?(require_dependency)
              require_dependency(file)
            else
              require(file)
            end
          end
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
