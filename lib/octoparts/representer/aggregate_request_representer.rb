require 'active_support/core_ext/string/inflections'

module Octoparts
  module Representer
    class Camelizer
      include Uber::Callable
      def initialize(camelcase)
        @camelcase = camelcase
      end

      def call(_represented, args)
        args[:camelize] ? @camelcase : @camelcase.underscore
      end
    end

    module AggregateRequestRepresenter
      include Representable::JSON

      property :request_meta, as: Camelizer.new('requestMeta'), class: Model::RequestMeta do
        property :id
        property :service_id, as: Camelizer.new('serviceId')
        property :user_id, as: Camelizer.new('userId')
        property :session_id, as: Camelizer.new('sessionId')
        property :request_url, as: Camelizer.new('requestUrl')
        property :user_agent, as: Camelizer.new('userAgent')
        property :timeout
      end

      collection :requests, class: Model::PartRequest do
        property :part_id, as: Camelizer.new('partId')
        property :id
        collection :params, class: Model::PartRequestParam do
          property :key
          property :value
        end
      end
    end
  end
end
