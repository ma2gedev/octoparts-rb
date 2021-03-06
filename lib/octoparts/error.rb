module Octoparts
  class Error < StandardError; end

  class ResponseError < Error
    attr_reader :response

    def self.from_response(response)
      status = response.status.to_i

      klass = case status
              when 400..499 then Octoparts::ClientError
              when 500..599 then Octoparts::ServerError
              end
      klass.new(response) unless klass.nil?
    end

    def initialize(response)
      @response = response
      super(error_message)
    end

    def error_message
      "status: #{@response.status}, body: #{@response.body}"
    end
  end

  class ClientError < ResponseError; end
  class ServerError < ResponseError; end
  class ArgumentError < Error; end
end
