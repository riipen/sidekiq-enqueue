# sidekiq-enqueue

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/riipen/sidekiq-enqueue/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/riipen/sidekiq-enqueue/tree/main)

Manually enqueue Sidekiq jobs from the web UI.

```
gem install sidekiq-enqueue
```

## Usage

To enable this extension, insert this piece of code in your app at the initialization stage:

```ruby
require 'sidekiq/enqueue'

Sidekiq::Enqueue.init
```

## Web UI

The web UI is accessible via `#{root_url}/#{sidekiq_web_path}/enqueue`.

## Release

Merging to `main` does not automatically publish a new gem version. Before another app can consume a new release by updating its `Gemfile`, publish the gem to RubyGems:

1. Update `Sidekiq::Enqueue::VERSION` in `lib/sidekiq/enqueue/version.rb`.
2. Update `CHANGELOG.md`.
3. Merge the release changes to `main`.
4. Run `bundle exec rake release`.

`bundle exec rake release` will build the gem, create a git tag for the version, and push the gem to RubyGems. After that, update the gem version in the other app's `Gemfile` and run Bundler as usual.
