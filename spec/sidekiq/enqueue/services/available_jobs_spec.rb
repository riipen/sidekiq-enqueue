# frozen_string_literal: true

require_relative "../../../../lib/sidekiq/enqueue/services/available_jobs"

RSpec.describe Sidekiq::Enqueue::Services::AvailableJobs do
  describe ".call" do
    it "returns loaded sidekiq job class names sorted alphabetically" do
      stub_const("SpecAlphaJob", Class.new do
        include Sidekiq::Job
      end)
      stub_const("SpecBetaJob", Class.new do
        include Sidekiq::Job
      end)
      stub_const("SpecPlainRubyClass", Class.new)

      expect(described_class.call).to include("SpecAlphaJob", "SpecBetaJob")
      expect(described_class.call).not_to include("SpecPlainRubyClass")
      expect(described_class.call & %w[SpecAlphaJob SpecBetaJob]).to eq(%w[SpecAlphaJob SpecBetaJob])
    end
  end
end
