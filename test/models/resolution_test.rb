require_relative "model_test_helper"
require 'traffic_spy/models/resolution'

class ResolutionTest < ModelTest
  def test_has_attributes
    resolution = TrafficSpy::Resolution.find_or_create_by('1920', '1280')
    assert_equal 1, resolution.id
    assert_equal '1920', resolution.width
    assert_equal '1280', resolution.height
  end

  def test_find_or_create_by_returns_Resolution_object_found_or_created
    TrafficSpy::Resolution.create('1920', '1280')
    resolution1 = TrafficSpy::Resolution.find_or_create_by('1920', '1280')
    resolution2 = TrafficSpy::Resolution.find_or_create_by('1920', '1280')
    assert_equal resolution1.id, resolution2.id
    assert_equal 1, TrafficSpy::Resolution.all.count
  end
end
