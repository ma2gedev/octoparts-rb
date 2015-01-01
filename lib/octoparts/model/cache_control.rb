module Octoparts
  module Model
    class CacheControl
      attr_accessor :no_store, :no_cache,
        :expires_at, :etag, :last_modified
    end
  end
end
