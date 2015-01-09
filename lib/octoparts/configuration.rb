module Octoparts
  class Configuration
    USER_AGENT = "Octoparts client ruby/#{Octoparts::VERSION}"

    attr_accessor :endpoint, :headers, :timeout, :open_timeout

    def initialize
      # set default values
      @endpoint = 'http://localhost:9000'
      @headers = {
        'User-Agent' => USER_AGENT
      }
      @timeout = nil
      @open_timeout = nil
    end
  end
end
