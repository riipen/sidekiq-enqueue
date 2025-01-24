# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Web
      module Routes
        class Enqueue
          def self.register(app)
            app.post "/enqueue" do
              Sidekiq::Enqueue::Services::Enqueue.new(params[:job_name], params[:arguments]).call

              redirect "#{root_path}enqueue"
            end
          end
        end
      end
    end
  end
end
