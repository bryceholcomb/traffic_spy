require_relative "model_test_helper"
require 'traffic_spy/models/source'

class SourceTest < ModelTest
  def test_has_attributes
    params = {'identifier' => 'jumpstartlab', 'rootUrl' => 'http://jumpstartlab.com'}
    TrafficSpy::Source.create(params)
    source = TrafficSpy::Source.find_by('jumpstartlab')
    assert_equal 1, source.id
    assert_equal 'jumpstartlab', source.identifier
    assert_equal 'http://jumpstartlab.com', source.root_url
  end
end
