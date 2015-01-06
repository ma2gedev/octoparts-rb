require 'helper'

class TestOctoparts < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Octoparts::VERSION
  end

  def test_it_does_something_useful
    assert { ['exist'].empty? == false }
  end
end
