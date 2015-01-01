module Octoparts
  module Model
    class Cookie
      attr_accessor :name, :value,
        :http_only, :secure, :discard,
        :max_age, :path, :domain
    end
  end
end
