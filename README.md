# Octoparts

[![Gem Version](https://badge.fury.io/rb/octoparts.svg)](http://badge.fury.io/rb/octoparts)

Octoparts Client for Ruby

Octoparts is the backend services aggregator. See more details [here](http://m3dev.github.io/octoparts/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'octoparts'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octoparts

## Usage

```ruby
# configuration
Octoparts.configure do |config|
  config.endpoint = 'http://localhost:9000'
  config.timeout_sec = 3       # open/read timeout in seconds
  config.open_timeout_sec = 1  # connection open timeout in seconds
end

# create client
client = Octoparts::Client.new

# invoke aggregate request with Hash
response = client.invoke({
  request_meta: {
    id: "test",
    timeout: 500
  },
  requests: [
    {
      part_id: "echo",
      params: [
        {
          key: "fooValue",
          value: "test"
        }
      ]
    }
  ]
})

response.status
response.body.responses.first.contents

# invoke with builder
aggregate_request = Octoparts.build_aggregate_request do
  request_meta(id: 'test', timeout: 500)
  requests do
    part_request(part_id: 'echo').add_param('fooValue', 'test')
  end
end
response = client.invoke(aggregate_request)

# cache invalidation
## post /octoparts/2/cache/invalidate/part/echo/fooValue/test
client.invalidate_cache('echo', param_name: 'fooValue', param_value: 'test')

## post /octoparts/2/cache/invalidate/cache-group/echo_group/params/fooValue
client.invalidate_cache_group('echo_group', param_value: 'fooValue')
```

## Contributing

1. Fork it ( https://github.com/m3dev/octoparts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
