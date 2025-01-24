# frozen_string_literal: true

module Sidekiq
  module Enqueue
    module Web
      module Routes
        class Index
          def self.register(app)
            app.get "/enqueue" do
              erb File.read(File.join(VIEW_PATH, "index.html.erb"))
            end
          end
        end
      end
    end
  end
end
