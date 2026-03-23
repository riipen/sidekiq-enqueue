# frozen_string_literal: true

require_relative "../../../../lib/sidekiq/enqueue/services/enqueue"

RSpec.describe Sidekiq::Enqueue::Services::Enqueue do
  subject(:service) { described_class }

  describe "#call" do
    it "enqueues a given job" do
      allow(Sidekiq::Enqueue::DummyJob).to receive(:perform_async).and_return(true)

      instance = service.new("Sidekiq::Enqueue::DummyJob", "[\"one\", \"two\"]")

      instance.call

      expect(Sidekiq::Enqueue::DummyJob).to have_received(:perform_async).with("one", "two")
    end

    it "raises when the job class cannot be found" do
      instance = service.new("Sidekiq::Enqueue::MissingJob", "[]")

      expect { instance.call }.to raise_error(NameError)
    end

    it "raises when arguments are not valid JSON" do
      instance = service.new("Sidekiq::Enqueue::DummyJob", "one, two")

      expect { instance.call }.to raise_error(JSON::ParserError)
    end

    it "raises when arguments are not a JSON array" do
      instance = service.new("Sidekiq::Enqueue::DummyJob", "{\"key\":\"value\"}")

      expect { instance.call }.to raise_error(ArgumentError, "Arguments must be a JSON array")
    end
  end
end
