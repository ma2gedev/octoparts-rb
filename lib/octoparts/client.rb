require 'uri'

module Octoparts
  class Client
    OCTOPARTS_API_ENDPOINT_PATH = '/octoparts/2'
    CACHE_API_ENDPOINT_PATH = "#{OCTOPARTS_API_ENDPOINT_PATH}/cache"

    def initialize(host: nil)
      @host = host || 'http://localhost:9000'
    end

    def get(path, params = nil, headers = nil)
      process(:get, path, params, headers)
    end

    def post(path, params = nil, headers = nil)
      process(:post, path, params, headers)
    end

    # TODO: doc
    def invoke(params, header = {})
      body = params.to_json # TODO
      header[:content_type] = 'application/json'
      resp = post(OCTOPARTS_API_ENDPOINT_PATH, body, header)
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
      resp = post(escaped_path, nil, nil)
      Response.new(
        resp.body,
        resp.headers,
        resp.status
      )
    end

    def process(method, path, params, headers)
      @connection ||= Faraday.new(url: @host) do |connection|
        connection.adapter Faraday.default_adapter
      end
      @connection.send(method, path, params, headers)
    end
  end
end
