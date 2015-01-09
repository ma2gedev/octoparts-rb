module Octoparts
  class Configuration
    USER_AGENT = "Octoparts client ruby/#{Octoparts::VERSION}"

    attr_accessor :endpoint, :headers, :timeout_sec, :open_timeout_sec

    def initialize
      # set default values
      @endpoint = 'http://localhost:9000'
      @headers = {
        'User-Agent' => USER_AGENT
      }
      @timeout_sec = nil
      @open_timeout_sec = nil
    end
  end
end
