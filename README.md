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
