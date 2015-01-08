# Octoparts

[![Coverage Status](https://img.shields.io/coveralls/ma2gedev/octoparts-rb.svg)](https://coveralls.io/r/ma2gedev/octoparts-rb)

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

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/octoparts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
