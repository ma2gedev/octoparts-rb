require "faraday"
require "octoparts/version"
require "octoparts/configuration"
require "octoparts/error"
require "octoparts/client"
require "octoparts/model"
require "octoparts/representer"
require "octoparts/response"
require "octoparts/builder"

module Octoparts
  class << self
    def configuration
      @configuration ||= Octoparts::Configuration.new
    end

    def configure(&block)
      configuration.instance_eval(&block)
    end

    def build_aggregate_request(&block)
      builder = Octoparts::AggregateRequestBuilder.new(&block)
      builder.build
    end
  end
end
