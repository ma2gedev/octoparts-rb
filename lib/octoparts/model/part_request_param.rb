module Octoparts
  module Model
    class PartRequestParam
      attr_accessor :key, :value

      def self.create(key, value)
        new.tap do |s|
          s.key = key
          s.value = value
        end
      end
    end
  end
end
