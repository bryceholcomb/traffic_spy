require_relative "controller_test_helper"

class DataPageTest < ControllerTest
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    @payload = 'payload={
                  "url":"http://jumpstartlab.com/blog",
                  "requestedAt":"2013-02-16 21:38:28 -0700",
                  "respondedIn":37,
                  "referredBy":"http://jumpstartlab.com",
                  "requestType":"GET",
                  "parameters":["article title", "article body"],
                  "eventName": "socialLogin",
                  "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                  "resolutionWidth":"1920",
                  "resolutionHeight":"1280",
                  "ip":"63.29.38.211"}'
  end

  def test_it_returns_200_with_params
    post '/sources/jumpstartlab/data', @payload
    assert_equal 200, last_response.status
  end

  def test_it_returns_400_with_missing_payload
    post '/sources/jumpstartlab/data'
    assert_equal 400, last_response.status
  end

  def test_it_returns_403_when_request_has_already_been_received
    post '/sources/jumpstartlab/data', @payload
    assert_equal 200, last_response.status

    post '/sources/jumpstartlab/data', @payload
    assert_equal 403, last_response.status
  end

  def test_it_returns_correct_source_id
    post '/sources/jumpstartlab/data', @payload
    assert_equal 1, TrafficSpy::DB.from(:data).select(:source_id).where(:requested_at => "2013-02-16 21:38:28 -0700").where(:source_id => 1).first[:source_id]

    post '/sources', 'identifier=krista&rootUrl=http://krista.com'
    post '/sources/krista/data', @payload
    assert_equal 2, TrafficSpy::DB.from(:data).select(:source_id).where(:requested_at => "2013-02-16 21:38:28 -0700").where(:source_id => 2).first[:source_id]
  end
end
