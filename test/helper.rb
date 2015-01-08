require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'octoparts'

require 'pry'
require 'test/unit'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
