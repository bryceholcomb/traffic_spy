require_relative "model_test_helper"
require 'traffic_spy/models/url'

class UrlTest < ModelTest
  def test_has_attributes
    url = TrafficSpy::Url.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal 1, url.id
    assert_equal 'http://jumpstartlab.com/blog', url.name
  end

  def test_find_or_create_by_returns_Url_object_found_or_created
    TrafficSpy::Url.create('http://jumpstartlab.com/blog')
    url1 = TrafficSpy::Url.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    url2 = TrafficSpy::Url.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal url1.id, url2.id
    assert_equal 1, TrafficSpy::Url.all.count
  end
end
