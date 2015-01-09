require 'active_support/core_ext/hash/keys'
require 'uri'

module Octoparts
  class Client
    OCTOPARTS_API_ENDPOINT_PATH = '/octoparts/2'
    CACHE_API_ENDPOINT_PATH = "#{OCTOPARTS_API_ENDPOINT_PATH}/cache"

    def initialize(endpoint: nil, headers: {}, timeout: nil, open_timeout: nil)
      @endpoint = endpoint || Octoparts.configuration.endpoint
      @timeout = timeout || Octoparts.configuration.timeout
      @open_timeout = open_timeout || Octoparts.configuration.open_timeout
      @headers = Octoparts.configuration.headers.merge(headers)
    end

    def get(path, params = {}, headers = {})
      process(:get, path, params, nil, headers)
    end

    def post(path, body = nil, headers = {})
      process(:post, path, {}, body, headers)
    end

    # TODO: doc
    def invoke(params)
      body = create_request_body(params)
      headers = { content_type: 'application/json' }
      resp = post(OCTOPARTS_API_ENDPOINT_PATH, body, headers)
      Response.new(
        Model::AggregateResponse.new.extend(Representer::AggregateResponseRepresenter).from_json(resp.body),
        resp.headers,
        resp.status
      )
    end

    # TODO: doc
    def invalidate_cache(part_id, param_name: nil, param_value: nil)
      cache_path = if param_name
        "/invalidate/part/#{part_id}/#{param_name}/#{param_value}"
      else
        "/invalidate/part/#{part_id}"
      end
      post_cache_api(cache_path)
    end

    # TODO: doc
    def invalidate_cache_group(cache_group_name, param_value: nil)
      cache_path = if param_value
        "/invalidate/cache-group/#{cache_group_name}/params/#{param_value}"
      else
        "/invalidate/cache-group/#{cache_group_name}/parts"
      end
      post_cache_api(cache_path)
    end

    private

    def post_cache_api(path)
      escaped_path = URI.escape("#{CACHE_API_ENDPOINT_PATH}#{path}")
      resp = post(escaped_path)
      Response.new(
        resp.body,
        resp.headers,
        resp.status
      )
    end

    def process(method, path, params, body, headers)
      @connection ||= Faraday.new(url: @endpoint) do |connection|
        connection.adapter Faraday.default_adapter
      end
      response = @connection.send(method) do |request|
        request.url(path, params)
        request.body = body if body
        request.headers.merge!(headers)
        request.options.timeout = @timeout if @timeout
        request.options.open_timeout = @open_timeout if @open_timeout
      end
      if error = Octoparts::ResponseError.from_response(response)
        raise error
      end
      response
    end

    def create_request_body(model)
      aggregate_request = case model
                          when Hash
                            stringify_params = model.deep_stringify_keys
                            Model::AggregateRequest.new.extend(Representer::AggregateRequestRepresenter).from_hash(stringify_params)
                          when Octoparts::Model::AggregateRequest
                            model.extend(Representer::AggregateRequestRepresenter)
                          else
                            raise Octopart::ArgumentError
                          end
      aggregate_request.to_json(camelize: true)
    end
  end
end
