module Octoparts
  class Configuration
    attr_accessor :endpoint

    def initialize
      # set default values
      @endpoint = 'http://localhost:9000'
    end
  end
end
