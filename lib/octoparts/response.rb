module Octoparts
  class Response
    attr_reader :body, :headers, :status

    def initialize(body, headers, status)
      @body = body
      @headers = headers
      @status = status
    end
  end
end
