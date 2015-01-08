module Octoparts
  class AggregateRequestBuilder
    def self.build(&block)
      builder = AggregateRequestBuilder.new(&block)
      builder.build
    end

    def initialize(&block)
      self.instance_eval(&block)
    end

    def request_meta(params)
      @request_meta = Octoparts::Model::RequestMeta.new
      params.each do |key, value|
        @request_meta.send("#{key}=", value)
      end
    end

    def requests(&block)
      self.instance_eval(&block)
    end

    def part_request(params)
      @requests ||= []
      part_request = Octoparts::Model::PartRequest.new
      params.each do |key, value|
        part_request.send("#{key}=", value)
      end
      @requests << part_request
      part_request
    end

    def build
      Octoparts::Model::AggregateRequest.create(@request_meta, @requests)
    end
  end
end
