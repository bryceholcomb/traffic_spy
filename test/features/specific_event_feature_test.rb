require_relative "feature_test_helper"

class SpecificEventFeatureTest < FeatureTest
  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    @payload1 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2013-03-16 21:38:28 -0700",
    "respondedIn":37,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin1",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"}'
    @payload2 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2014-02-16 21:40:28 -0700",
    "respondedIn":37,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"}'
    @payload3 = 'payload={
    "url":"http://jumpstartlab.com/article",
    "requestedAt":"2013-02-16 01:40:28 -0700",
    "respondedIn":40,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin1",
    "userAgent":"Chrome/5.0 (Windows%3B Intel) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"2000",
    "resolutionHeight":"1000",
    "ip":"63.29.38.212"}'
    @payload4 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2013-03-17 21:38:28 -0700",
    "respondedIn":37,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin1",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.241"}'
    post '/sources/jumpstartlab/data', @payload1
    post '/sources/jumpstartlab/data', @payload2
    post '/sources/jumpstartlab/data', @payload3
    post '/sources/jumpstartlab/data', @payload4
  end

  def test_has_header
    visit '/sources/jumpstartlab/events/socialLogin1'
    within('h1') do
      assert page.has_content?('More details for Jumpstartlab, Event: socialLogin')
    end
  end

  def test_error_page_when_undefined_event
    visit '/sources/jumpstartlab/events/fail'
    within('h1') do
      assert page.has_content?('Error: no event with the name fail has been defined for Jumpstartlab')
    end
  end

  def test_error_page_when_undefined_identifier
    visit '/sources/bryce/events/fail'
    within('h1') do
      assert page.has_content?('Error: unknown source, Bryce')
    end
  end

  def test_hour_by_hour_breakdown
    visit '/sources/jumpstartlab/events/socialLogin1'
    within('#hour_by_hour') do
      assert page.has_content?('Hour by hour breakdown of when events are recieved')

      within('#hour_21') do
        assert page.has_content?('21: 2')
      end
    end
  end

  def test_shows_how_many_times_it_was_recieved_overall
    visit '/sources/jumpstartlab/events/socialLogin1'
    within('#times_received') do
      assert page.has_content?('Times event has been received: 3')
    end
  end
end
