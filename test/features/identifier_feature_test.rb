require_relative "feature_test_helper"

class IdentifierFeatureTest < FeatureTest
  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'

    @payload1 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2012-02-16 21:38:28 -0700",
    "respondedIn":37,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"}'

    @payload2 = 'payload={
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

    @payload3 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2014-02-16 21:38:28 -0700",
    "respondedIn":40,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"}'

    @payload4 = 'payload={
    "url":"http://jumpstartlab.com/article/1",
    "requestedAt":"2013-02-16 21:40:28 -0700",
    "respondedIn":40,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Chrome/5.0 (Windows%3B Intel) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"2000",
    "resolutionHeight":"1000",
    "ip":"63.29.38.212"}'

    post '/sources/jumpstartlab/data', @payload1
    post '/sources/jumpstartlab/data', @payload2
    post '/sources/jumpstartlab/data', @payload3
    post '/sources/jumpstartlab/data', @payload4
  end

  def test_has_header
    visit '/sources/jumpstartlab'
    within('h1') do
      assert page.has_content?('Jumpstartlab Stats')
    end
  end

  def test_presents_most_to_least_urls
    visit '/sources/jumpstartlab'
    within('#url_stats') do
      assert page.has_content?('Most Requested Urls')
      within('#url_0') do
        assert page.has_content?('http://jumpstartlab.com/blog')
      end
      within('#url_1') do
        assert page.has_content?('http://jumpstartlab.com/article')
      end
    end
  end

  def test_presents_browser_breakdown_across_all_requests
    visit '/sources/jumpstartlab'
    within('#browser_stats') do
      within('h2') do
        assert page.has_content?('Most Popular Browsers')
      end
      within('#browser_0') do
        assert page.has_content?('Mozilla/5.0')
      end
      within('#browser_1') do
        assert page.has_content?('Chrome/5.0')
      end
    end
  end

  def test_presents_os_breakdown_across_all_requests
    visit '/sources/jumpstartlab'
    within('#os_stats') do
      within('h2') do
        assert page.has_content?('Most Popular Operating Systems')
      end
      within('#os_0') do
        assert page.has_content?('Macintosh; Intel Mac OS X 10_8_2')
      end
      within('#os_1') do
        assert page.has_content?('Windows; Intel')
      end
    end
  end

  def test_presents_screen_resolution_breakdown_across_all_requests
    visit '/sources/jumpstartlab'
    within('#resolution_stats') do
      within('h2') do
        assert page.has_content?('Most Popular Screen Resolutions')
      end
      within('#resolution_0') do
        assert page.has_content?('1920 x 1280')
      end
      within('#resolution_1') do
        assert page.has_content?('2000 x 1000')
      end
    end
  end

  def test_presents_response_time_breakdown_across_all_requests
    visit '/sources/jumpstartlab'
    within('#response_time_stats') do
      within('h2') do
        assert page.has_content?('Average Response Times Per Url')
      end
      within('#resp_time_0') do
        assert page.has_content?("http://jumpstartlab.com/article")
      end
    end
  end

  def test_has_all_url_links
    visit '/sources/jumpstartlab'
    within('#url_stats') do
      within('#url_0') do
        assert page.has_content?('http://jumpstartlab.com/blog')
      end
    end
    click_link('url_0')
    assert_equal '/sources/jumpstartlab/urls/blog', current_path
  end

  def test_url_link_with_long_path_works
    visit '/sources/jumpstartlab'
    within('#url_stats') do
      within('#url_1') do
        assert page.has_content?('http://jumpstartlab.com/article/1')
      end
    end
    click_link('url_1')
    assert_equal '/sources/jumpstartlab/urls/article/1', current_path
  end

  def test_has_aggregate_event_link
    visit '/sources/jumpstartlab'
    within('#events') do
      assert page.has_content?('Events Information')
    end
    click_link('events')
    assert_equal '/sources/jumpstartlab/events', current_path
  end
end
