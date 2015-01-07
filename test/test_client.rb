require 'helper'

class TestClient < Test::Unit::TestCase
  def setup
    @client = Octoparts::Client.new
  end

  sub_test_case "#invoke" do
    test "normal invoke" do
      VCR.use_cassette 'invoke_example' do
        response = @client.invoke({
          "request_meta" => {
            "id" => "test",
            "timeout" => 500
          },
          "requests" => [
            "part_id" => "echo",
            "params" => [
              {
                "key" => "fooValue",
                "value" => "test"
              }
            ]
          ]
        })
        body = response.body
        assert { body.class == Octoparts::Model::AggregateResponse }
        assert { body.response_meta.class == Octoparts::Model::ResponseMeta }
        assert { body.responses.first.class == Octoparts::Model::PartResponse }
        assert { body.responses.first.cache_control.class == Octoparts::Model::CacheControl }
        assert { body.responses.size == 1 }
        assert { body.responses.first.contents =~ /"test"/ }
      end
    end

    test "normal invoke when 2 requests" do
      VCR.use_cassette 'invoke_with_2_requests' do
        response = @client.invoke({
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
            },
            {
              part_id: "echo",
              params: [
                {
                  key: "fooValue",
                  value: "hoge"
                }
              ]
            }
          ]
        })
        body = response.body
        assert { body.class == Octoparts::Model::AggregateResponse }
        assert { body.response_meta.class == Octoparts::Model::ResponseMeta }
        assert { body.responses.first.class == Octoparts::Model::PartResponse }
        assert { body.responses.first.cache_control.class == Octoparts::Model::CacheControl }
        assert { body.responses.size == 2 }
        assert { body.responses.first.contents =~ /"test"/ }
        assert { body.responses.last.contents =~ /"hoge"/ }
      end
    end
  end
end
