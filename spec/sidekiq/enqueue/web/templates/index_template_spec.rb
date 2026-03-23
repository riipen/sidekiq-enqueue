# frozen_string_literal: true

require "erb"

require_relative "../../../../../lib/sidekiq/enqueue/web"

RSpec.describe "enqueue index template" do
  let(:template) do
    File.read("/Users/riipen/Documents/Riipen/sidekiq-enqueue/lib/sidekiq/enqueue/web/templates/index.html.erb")
  end

  let(:context) do
    Object.new.tap do |view|
      view.define_singleton_method(:csp_nonce) { "nonce" }
      view.define_singleton_method(:root_path) { "/" }
      view.define_singleton_method(:csrf_tag) { "" }
      view.define_singleton_method(:t) do |key, default: nil|
        {
          "sidekiq_enqueue" => "Enqueue Job",
          "sidekiq_enqueue_job_name" => "Job Name",
          "sidekiq_enqueue_job_name_hint" => "Search for or enter the worker class name to enqueue.",
          "sidekiq_enqueue_jobs_load_error" => "Unable to load available jobs.",
          "sidekiq_enqueue_arguments" => "Arguments",
          "sidekiq_enqueue_arguments_hint" => "Enter a comma-separated list of arguments to pass to the job.",
          "sidekiq_enqueue_submit" => "Submit"
        }.fetch(key, default)
      end
    end
  end

  it "shows an error message instead of a selectable item when jobs fail to load" do
    allow(Sidekiq::Enqueue::Services::AvailableJobs).to receive(:call).and_raise(StandardError)

    rendered = ERB.new(template).result(context.instance_eval { binding })

    expect(rendered).to include("Unable to load available jobs.")
    expect(rendered).not_to include("<option value=\"Error Loading Jobs\"></option>")
  end
end
