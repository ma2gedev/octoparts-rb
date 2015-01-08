module Octoparts
  module Model
    class AggregateRequest
      attr_accessor :request_meta, :requests

      def self.create(request_meta, requests)
        new.tap do |s|
          s.request_meta = request_meta
          s.requests = requests
        end
      end
    end
  end
end
