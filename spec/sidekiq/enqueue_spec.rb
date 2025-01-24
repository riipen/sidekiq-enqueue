# frozen_string_literal: true

require_relative "../../lib/sidekiq/enqueue"

RSpec.describe Sidekiq::Enqueue do
  subject(:enqueue) { described_class }

  describe ".init" do
    it "registers web" do
      allow(Sidekiq::Web).to receive(:register).with(Sidekiq::Enqueue::Web).and_return(true)

      enqueue.init

      expect(Sidekiq::Web).to have_received(:register).with(Sidekiq::Enqueue::Web)
    end
  end
end
