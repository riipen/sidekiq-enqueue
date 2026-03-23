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
        { "job_name" => "Sidekiq::Enqueue::DummyJob", "arguments" => "one, two" }[key]
      end
      context.define_singleton_method(:root_path) { "/" }
      context.define_singleton_method(:redirect) { |path| path }

      result = context.instance_exec(&registered_block)

      expect(Sidekiq::Enqueue::Services::Enqueue).to have_received(:new).with("Sidekiq::Enqueue::DummyJob", "one, two")
      expect(service).to have_received(:call)
      expect(result).to eq("/enqueue")
    end

    it "exposes enqueue errors to the view" do
      registered_block = nil
      app = double("app")
      error = NameError.new("uninitialized constant MissingJob")
      service = instance_double(Sidekiq::Enqueue::Services::Enqueue)

      allow(app).to receive(:post) do |_path, &block|
        registered_block = block
      end
      allow(Sidekiq::Enqueue::Services::Enqueue).to receive(:new).and_return(service)
      allow(service).to receive(:call).and_raise(error)

      described_class.register(app)

      captured_error = nil
      context = Object.new
      context.define_singleton_method(:url_params) do |key|
        { "job_name" => "MissingJob", "arguments" => "[]" }[key]
      end
      context.define_singleton_method(:erb) do |_template|
        captured_error = @enqueue_error
        :rendered
      end

      result = context.instance_exec(&registered_block)

      expect(result).to eq(:rendered)
      expect(captured_error).to be(error)
    end

    it "renders the form with an error when job name is blank" do
      registered_block = nil
      app = double("app")

      allow(app).to receive(:post) do |_path, &block|
        registered_block = block
      end
      allow(Sidekiq::Enqueue::Services::Enqueue).to receive(:new)

      described_class.register(app)

      captured_error = nil
      context = Object.new
      context.define_singleton_method(:url_params) do |key|
        { "job_name" => "", "arguments" => "one, two" }[key]
      end
      context.define_singleton_method(:erb) do |_template|
        captured_error = @enqueue_error
        :rendered
      end

      result = context.instance_exec(&registered_block)

      expect(result).to eq(:rendered)
      expect(captured_error).to be_a(StandardError)
      expect(captured_error.message).to eq("Job name is required")
      expect(Sidekiq::Enqueue::Services::Enqueue).not_to have_received(:new)
    end
  end
end
