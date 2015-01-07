# Octoparts

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

# invoke aggregate request
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
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/octoparts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
