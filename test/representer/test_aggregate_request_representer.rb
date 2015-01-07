require 'helper'
require 'json'
require 'active_support/core_ext/string/inflections'

class TestAggregateRequestRepresenter < Test::Unit::TestCase
  def setup
    @json = <<-"JSON"
{
  "request_meta": {
    "id": "id",
    "service_id": "serviceId",
    "user_id": "userId",
    "session_id": "sessionId",
    "request_url": "requestUrl",
    "user_agent": "userAgent",
    "timeout": 500
  },
  "requests": [
    {
      "part_id": "partId",
      "id": "id",
      "params": [
        {
          "key": "fooValue",
          "value": "test"
        },
        {
          "key": "nya-",
          "value": "nya-"
        }
      ]
    }
  ]
}
    JSON
  end

  def convert_hash_keys(value)
    case value
    when Array
      value.map { |v| convert_hash_keys(v) }
    when Hash
      Hash[value.map { |k, v| [k.camelcase(:lower), convert_hash_keys(v)] }]
    else
      value
    end
  end

  test "underscored keys can change to underscored keys json" do
    aggregate_request = Octoparts::Model::AggregateRequest.new
      .extend(Octoparts::Representer::AggregateRequestRepresenter).from_hash(JSON.parse(@json))
    assert do
      JSON.parse(aggregate_request.to_json) == JSON.parse(@json)
    end
  end

  test "underscored keys can change to camelcase keys json" do
    aggregate_request = Octoparts::Model::AggregateRequest.new
      .extend(Octoparts::Representer::AggregateRequestRepresenter).from_hash(JSON.parse(@json))
    assert do
      JSON.parse(aggregate_request.to_json(camelize: true)) == convert_hash_keys(JSON.parse(@json))
    end
  end
end
