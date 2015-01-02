require_relative "model_test_helper"
require 'traffic_spy/models/source'

class SourceTest < ModelTest
  def test_has_attributes
    source = TrafficSpy::Source.find_or_create_by(:rootUrl, 'http://jumpstartlab.com/blog')
    assert_equal 1, source.id
    assert_equal 'jumpstartlab', source.identifier
    assert_equal 'http://jumpstartlab.com', source.rootUrl
  end
end
