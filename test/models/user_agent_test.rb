require_relative "model_test_helper"
require 'traffic_spy/models/user_agent'

class UserAgentTest < ModelTest
  def test_has_attributes
    user_agent = TrafficSpy::UserAgent.find_or_create_by(:data, "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    assert_equal 1, user_agent.id
    assert_equal "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", user_agent.data
    assert_equal "Macintosh%3B Intel Mac OS X 10_8_2", user_agent.os
    assert_equal "Mozilla/5.0", user_agent.browser
  end

  def test_find_or_create_by_returns_UserAgent_object_found_or_created
    TrafficSpy::UserAgent.create("Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    user_agent1 = TrafficSpy::UserAgent.find_or_create_by(:data, "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    user_agent2 = TrafficSpy::UserAgent.find_or_create_by(:data, "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    assert_equal user_agent1.id, user_agent2.id
    assert_equal 1, TrafficSpy::UserAgent.all.count
  end
end
