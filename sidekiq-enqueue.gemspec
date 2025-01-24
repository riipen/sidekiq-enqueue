# frozen_string_literal: true

require_relative "lib/sidekiq/enqueue/version"

Gem::Specification.new do |spec|
  spec.name = "sidekiq-enqueue"
  spec.version = Sidekiq::Enqueue::VERSION
  spec.authors = ["Jordan Ell"]
  spec.email = ["jordan.ell@riipen.com"]

  spec.summary = "Manually enqueue Sidekiq jobs from the web UI."
  spec.homepage = "https://github.com/riipen/sidekiq-enqueue"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/riipen/sidekiq-enqueue/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.12.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.6.0"
  spec.add_development_dependency "rubocop", "~> 1.69.2"
  spec.add_development_dependency "rubocop-rspec", "~> 3.0.4"

  spec.add_dependency "sidekiq", "< 8"

  spec.metadata["rubygems_mfa_required"] = "true"
end
