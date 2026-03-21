# frozen_string_literal: true

require_relative "../../../../../lib/sidekiq/enqueue/web/routes/index"

RSpec.describe Sidekiq::Enqueue::Web::Routes::Index do
  describe ".register" do
    it "renders the template with available jobs" do
      registered_block = nil
      app = double("app")

      allow(app).to receive(:get) do |_path, &block|
        registered_block = block
      end
      described_class.register(app)

      context = Object.new
      context.define_singleton_method(:erb) { |_template| :rendered }

      result = context.instance_exec(&registered_block)

      expect(result).to eq(:rendered)
    end

    it "renders even if the first render attempt raises" do
      registered_block = nil
      app = double("app")

      allow(app).to receive(:get) do |_path, &block|
        registered_block = block
      end
      described_class.register(app)

      context = Object.new
      call_count = 0
      context.define_singleton_method(:erb) do |_template|
        call_count += 1
        raise StandardError if call_count == 1

        :rendered
      end

      result = context.instance_exec(&registered_block)

      expect(result).to eq(:rendered)
    end
  end
end
