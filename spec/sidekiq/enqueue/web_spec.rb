# frozen_string_literal: true

require_relative "../../../lib/sidekiq/enqueue/web"

RSpec.describe Sidekiq::Enqueue::Web do
  subject(:web) { described_class }

  describe ".registered" do
    it "registers enqueue route" do
      allow(Sidekiq::Enqueue::Web::Routes::Enqueue).to receive(:register).and_return(true)

      app = double(get: true, post: true)

      web.registered(app)

      expect(Sidekiq::Enqueue::Web::Routes::Enqueue).to have_received(:register).with(app)
    end

    it "registers index route" do
      allow(Sidekiq::Enqueue::Web::Routes::Index).to receive(:register).and_return(true)

      app = double(get: true, post: true)

      web.registered(app)

      expect(Sidekiq::Enqueue::Web::Routes::Index).to have_received(:register).with(app)
    end
  end
end
