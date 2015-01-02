require_relative "model_test_helper"
require 'traffic_spy/models/event'

class EventTest < ModelTest
  def test_has_attributes
    event = TrafficSpy::Event.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal 1, event.id
    assert_equal 'http://jumpstartlab.com/blog', event.name
  end

  def test_find_or_create_by_returns_Event_object_found_or_created
    TrafficSpy::Event.create('http://jumpstartlab.com/blog')
    event1 = TrafficSpy::Event.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    event2 = TrafficSpy::Event.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal event1.id, event2.id
    assert_equal 1, TrafficSpy::Event.all.count
  end
end
