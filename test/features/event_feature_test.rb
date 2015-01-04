require_relative "feature_test_helper"

class EventFeatureTest < FeatureTest
  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    post '/sources', 'identifier=bryce&rootUrl=http://bryce.com'
    @payload1 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2013-02-16 21:38:28 -0700",
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
    "requestedAt":"2014-02-16 21:38:28 -0700",
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
    "requestedAt":"2013-02-16 21:40:28 -0700",
    "respondedIn":40,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin1",
    "userAgent":"Chrome/5.0 (Windows%3B Intel) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"2000",
    "resolutionHeight":"1000",
    "ip":"63.29.38.212"}'
    post '/sources/jumpstartlab/data', @payload1
    post '/sources/jumpstartlab/data', @payload2
    post '/sources/jumpstartlab/data', @payload3
  end

  def test_has_header
    visit '/sources/jumpstartlab/events'
    within('h1') do
      assert page.has_content?('Jumpstartlab Events')
    end
  end

  # def test_jjl
  #   get '/sources/krista/events'
  #   assert_equal 404, last_response.status
  # end

  # isn't loading the identifier_error_page??
  def test_view_for_unknown_identifier
    visit '/sources/krista/events'
    within('h1') do
      assert page.has_content?('Error: unknown source, Krista')
    end
  end

  def test_view_for_defined_identifier_no_events
  visit '/sources/bryce/events'
  within('h1') do
    assert page.has_content?('No events have been defined for source: Bryce')
  end
end

  def test_presents_most_to_least_events
    visit '/sources/jumpstartlab/events'
    within('#event_stats') do
      assert page.has_content?('Most Recieved Event')
      within('#event_0') do
        assert page.has_content?('socialLogin1')
      end
      within('#event_1') do
        assert page.has_content?('socialLogin')
      end
    end
  end

  def test_provides_links
    visit '/sources/jumpstartlab/events'
    within('#event_links') do
      assert page.has_content? ('Click Event Links for more info')
    end
    within('#event_link_0') do
      assert page.has_content?('socialLogin1')
    end
    within('#event_link_1') do
     assert page.has_content?('socialLogin')
    end
    click_link('socialLogin')
    assert_equal '/sources/jumpstartlab/events/socialLogin', current_path
  end
end
