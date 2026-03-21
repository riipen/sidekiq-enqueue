# frozen_string_literal: true

require_relative "../../../../../lib/sidekiq/enqueue/web/routes/enqueue"

RSpec.describe Sidekiq::Enqueue::Web::Routes::Enqueue do
  describe ".register" do
    it "passes url params to the enqueue service and redirects back to the form" do
      registered_block = nil
      app = double("app")
      service = instance_double(Sidekiq::Enqueue::Services::Enqueue, call: true)

      allow(app).to receive(:post) do |_path, &block|
        registered_block = block
      end
      allow(Sidekiq::Enqueue::Services::Enqueue).to receive(:new).and_return(service)

      described_class.register(app)

      context = Object.new
      context.define_singleton_method(:url_params) do |key|
        {"job_name" => "Sidekiq::Enqueue::DummyJob", "arguments" => "one, two"}[key]
      end
      context.define_singleton_method(:root_path) { "/" }
      context.define_singleton_method(:redirect) { |path| path }

      result = context.instance_exec(&registered_block)

      expect(Sidekiq::Enqueue::Services::Enqueue).to have_received(:new).with("Sidekiq::Enqueue::DummyJob", "one, two")
      expect(service).to have_received(:call)
      expect(result).to eq("/enqueue")
    end
  end
end
