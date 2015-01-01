module Octoparts
  module Model
    class PartResponse
      attr_accessor :part_id, :id, :cookies,
        :status_code, :mime_type, :charset,
        :cache_control, :contents, :warnings,
        :errors, :retrieved_from_cache
    end
  end
end
