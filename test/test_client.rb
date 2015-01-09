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

    test "normal invoke with AggregateRequest model" do
      VCR.use_cassette 'invoke_with_aggregate_request' do
        aggregate_request = Octoparts.build_aggregate_request do
          request_meta(id: 'test', timeout: 500)
          requests do
            part_request(part_id: 'echo').add_param('fooValue', 'test')
          end
        end
        stub_request(:post, 'localhost:9000')
        response = @client.invoke(aggregate_request)
        body = response.body
        assert { body.class == Octoparts::Model::AggregateResponse }
        assert { body.response_meta.class == Octoparts::Model::ResponseMeta }
        assert { body.responses.first.class == Octoparts::Model::PartResponse }
        assert { body.responses.first.cache_control.class == Octoparts::Model::CacheControl }
        assert { body.responses.size == 1 }
        assert { body.responses.first.contents =~ /"test"/ }
        assert_requested(:post, "http://localhost:9000/octoparts/2") do |req|
          req.body == '{"requestMeta":{"id":"test","timeout":500},"requests":[{"partId":"echo","params":[{"key":"fooValue","value":"test"}]}]}'
        end
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

    test "invalid parameters" do
      VCR.use_cassette 'invoke_with_invalid_parameters' do
        assert_raise Octoparts::ClientError do
          response = @client.invoke({
            "request_meta" => {
              "timeout" => 500
            }
          })
        end
      end
    end
  end

  sub_test_case "timeout" do
    teardown do
      Octoparts.configure do |c|
        c.timeout_sec = nil
      end
    end

    test "timeout_sec option" do
      assert_raise Faraday::TimeoutError do
        Octoparts::Client.new(timeout_sec: 0).get('/')
      end
    end

    test "open_timeout_sec option" do
      Octoparts.configure do |c|
        c.timeout_sec = 0
      end
      assert_raise Faraday::TimeoutError do
        Octoparts::Client.new.get('/')
      end
    end
  end
end
