require_relative "../test_helper"

class DataTest < Minitest::Test
  def setup
    # payload = this should be a json object
  end

  def test_has_url_attributes

    payload = {"url" => "http://jumpstartlab.com/blog",
      "requestedAt" => "2013-02-16 21:38:28 -0700",
      "respondedIn" => 37,
      "referredBy" => "http://jumpstartlab.com",
      "requestType" => "GET",
      "parameters" => [],
      "eventName" => "socialLogin",
      "userAgent" => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth" => "1920",
      "resolutionHeight" => "1280",
      "ip" => "63.29.38.211"}
    TrafficSpy::Data.create(payload)
    data = TrafficSpy::Data.all.last
    assert_equal 1, data.url_id
    # assert_equal "http://jumpstartlab.com/blog", data.url
  end
end
