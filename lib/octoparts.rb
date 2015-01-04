require "json"
require "faraday"
require "octoparts/version"
require "octoparts/configuration"
require "octoparts/client"
require "octoparts/model"
require "octoparts/representer"
require "octoparts/response"

module Octoparts
  class << self
    def configuration
      @configuration ||= Octoparts::Configuration.new
    end

    def configure(&block)
      configuration.instance_eval(&block)
    end
  end
end
