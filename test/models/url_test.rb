require_relative "../test_helper"
require 'traffic_spy/models/url'

class UrlTest < Minitest::Test
  def teardown
    TrafficSpy::DB.from(:urls).delete
    # TrafficSpy::DB.from(:sources).delete
    # TrafficSpy::DB.from(:data).delete
    TrafficSpy::DB.from(:sqlite_sequence).delete
  end

  def test_has_attributes
    TrafficSpy::Url.create('http://jumpstartlab.com/blog')
    url = TrafficSpy::Url.find_by_name('http://jumpstartlab.com/blog')
    assert_equal 1, url.id
    assert_equal 'http://jumpstartlab.com/blog', url.name
  end
end
