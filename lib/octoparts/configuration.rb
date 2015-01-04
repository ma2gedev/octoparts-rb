module Octoparts
  class Configuration
    USER_AGENT = "Octoparts client ruby/#{Octoparts::VERSION}"

    attr_accessor :endpoint, :headers

    def initialize
      # set default values
      @endpoint = 'http://localhost:9000'
      @headers = {
        'User-Agent' => USER_AGENT
      }
    end
  end
end
