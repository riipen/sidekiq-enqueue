# frozen_string_literal: true

require_relative "../../../../lib/sidekiq/enqueue/services/enqueue"

RSpec.describe Sidekiq::Enqueue::Services::Enqueue do
  subject(:service) { described_class }

  describe "#call" do
    it "enqueues a given job" do
      allow(Sidekiq::Enqueue::DummyJob).to receive(:perform_async).and_return(true)

      instance = service.new("Sidekiq::Enqueue::DummyJob", "")

      instance.call

      expect(Sidekiq::Enqueue::DummyJob).to have_received(:perform_async)
    end
  end
end
