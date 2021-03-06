module Octoparts
  module Model
    class PartRequest
      attr_accessor :part_id, :id, :params

      def initialize
        @params = []
      end

      def add_param(key, value)
        @params << Octoparts::Model::PartRequestParam.create(key, value)
        self
      end
    end
  end
end
