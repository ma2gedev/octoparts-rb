module Octoparts
  module Representer
    module AggregateResponseRepresenter
      include Representable::JSON

      property :response_meta, as: :responseMeta, class: Model::ResponseMeta do
        property :id
        property :process_time, as: :processTime
      end

      collection :responses, class: Model::PartResponse do
        property :part_id, as: :partId
        property :id
        collection :cookies, class: Model::Cookie do
          property :name
          property :value
          property :http_only, as: :httpOnly
          property :secure
          property :discard
          property :max_age, as: :maxAge
          property :path
          property :domain
        end
        property :status_code, as: :statusCode
        property :mime_type, as: :mimeType
        property :charset
        property :cache_control, as: :cacheControl, class: Model::CacheControl do
          property :no_store, as: :noStore
          property :no_cache, as: :noCache
          property :expires_at, as: :expiresAt
          property :etag
          property :last_modified, as: :lastModified
        end
        property :contents
        property :warnings
        property :errors
        property :retrieved_from_cache, as: :retrievedFromCache
      end
    end
  end
end
