module Octoparts
  module Model
    class RequestMeta
      attr_accessor :id, :service_id, :user_id, :session_id,
        :request_url, :user_agent, :timeout
    end
  end
end
