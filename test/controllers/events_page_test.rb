require_relative "controller_test_helper"

class EventsPageTest < ControllerTest
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
    post '/sources/jumpstartlab/data', @payload
    post '/sources', 'identifier=krista&rootUrl=http://krista.com'
  end

  def test_200_for_defined_source_with_events
    get '/sources/jumpstartlab/events'
    assert_equal 200, last_response.status
  end

  # def test_404_for_defined_source_no_events
  #   get '/sources/krista/events'
  #   assert_equal 200, last_response.status
  # end
  #
  # def test_404_for_undefined_source
  #   get '/sources/bryce/events'
  #   assert_equal 200, last_response.status
  # end
end
