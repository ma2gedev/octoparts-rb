module Octoparts
  module Representer
    module AggregateRequestRepresenter
      include Representable::JSON

      property :request_meta, as: :requestMeta, class: Model::RequestMeta do
        property :id
        property :service_id, as: :serviceId
        property :user_id, as: :userId
        property :session_id, as: :sessionId
        property :request_url, as: :requestUrl
        property :user_agent, as: :userAgent
        property :timeout
      end

      collection :requests, class: Model::PartRequest do
        property :part_id, as: :partId
        property :id
        collection :params, class: Model::PartRequestParam do
          property :key
          property :value
        end
      end
    end
  end
end
