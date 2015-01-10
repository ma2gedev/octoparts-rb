require 'helper'

class TestOctoparts < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Octoparts::VERSION
  end

  test ".configuration" do
    assert { Octoparts.configuration.class == Octoparts::Configuration }
  end

  test ".configure" do
    Octoparts.configure { |c| c.open_timeout_sec = 2 }
    teardown do
      Octoparts.configure { |c| c.open_timeout_sec = nil }
    end

    assert { Octoparts.configuration.open_timeout_sec == 2 }
  end

  test "Octoparts.create_aggregate_request" do
    aggregate_request = Octoparts.build_aggregate_request do
      request_meta(id: 'id')
    end
    assert { aggregate_request.request_meta.class == Octoparts::Model::RequestMeta }
  end
end
