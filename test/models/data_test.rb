require_relative "model_test_helper"

class DataTest < ModelTest
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    @payload = {"url" => "http://jumpstartlab.com/blog",
      "requestedAt" => "2013-02-16 21:38:28 -0700",
      "respondedIn" => 37,
      "referredBy" => "http://jumpstartlab.com",
      "requestType" => "GET",
      "parameters" => '',
      "eventName" => "socialLogin",
      "userAgent" => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "1920",
      "resolutionHeight" => "1280",
      "ip" => "63.29.38.211"}
  end

  def test_has_attributes
    TrafficSpy::Data.find_or_create_by(@payload, 'jumpstartlab')
    data = TrafficSpy::Data.all.last
    assert_equal 1, data.url_id
    assert_equal 1, data.referral_id
    assert_equal 1, data.event_id
    assert_equal 1, data.user_agent_id
    assert_equal 1, data.resolution_id
    assert_equal 1, data.source_id
    # assert_equal "http://jumpstartlab.com/blog", data.url
  end

  def test_can_determine_if_payload_is_a_duplicate
    payload1 = TrafficSpy::Data.find_or_create_by(@payload, 'jumpstartlab')
    payload2 = TrafficSpy::Data.find_or_create_by(@payload, 'jumpstartlab')
    assert_equal payload1.id, payload2.id
    assert_equal 1, TrafficSpy::Data.all.count
  end

  def test_can_find_by_payload
    found_payload = TrafficSpy::Data.find_or_create_by(@payload, 'jumpstartlab')
    assert_equal @payload['requestedAt'], found_payload.requested_at
  end
end
