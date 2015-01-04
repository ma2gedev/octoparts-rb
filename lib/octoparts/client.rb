module Octoparts
  class Client
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
      resp = post("/octoparts/2", body, header)
      Response.new(
        Model::AggregateResponse.new.extend(Representer::AggregateResponseRepresenter).from_json(resp.body),
        resp.headers,
        resp.status
      )
    end

    private

    def process(method, path, params, headers)
      connection = Faraday.new(url: @host) do |connection|
        connection.adapter Faraday.default_adapter
      end
      connection.send(method, path, params, headers)
    end
  end
end
