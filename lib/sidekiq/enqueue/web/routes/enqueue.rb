# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Web
      module Routes
        class Enqueue
          def self.register(app)
            app.post "/enqueue" do
              raise StandardError, "Job name is required" if url_params("job_name").nil? || url_params("job_name").empty?

              Sidekiq::Enqueue::Services::Enqueue.new(url_params("job_name"), url_params("arguments")).call

              redirect "#{root_path}enqueue"
            rescue StandardError
              erb File.read(File.join(VIEW_PATH, "index.html.erb"))
            end
          end
        end
      end
    end
  end
end
