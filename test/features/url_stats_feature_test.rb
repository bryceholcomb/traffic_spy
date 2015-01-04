require_relative "feature_test_helper"

class UrlStatsFeatureTest < FeatureTest
  def setup
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    @payload1 = 'payload={
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
    @payload2 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2014-02-16 21:38:28 -0700",
    "respondedIn":24,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"PUT",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"}'
    @payload3 = 'payload={
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2013-02-16 21:40:28 -0700",
    "respondedIn":40,
    "referredBy":"http://google.com",
    "requestType":"POST",
    "parameters":["article title", "article body"],
    "eventName": "socialLogin",
    "userAgent":"Chrome/5.0 (Windows%3B Intel) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"2000",
    "resolutionHeight":"1000",
    "ip":"63.29.38.212"}'
    post '/sources/jumpstartlab/data', @payload1
    post '/sources/jumpstartlab/data', @payload2
    post '/sources/jumpstartlab/data', @payload3
  end

  def test_has_indentifier
    visit '/sources/jumpstartlab/urls/blog'
    within('h1') do
      assert page.has_content?('Jumpstartlab')
    end
  end

  def test_has_header
    visit '/sources/jumpstartlab/urls/blog'
    within('h2') do
      assert page.has_content?('URL Stats')
    end
  end

  def test_presents_longest_response_time
    visit '/sources/jumpstartlab/urls/blog'
    within('#long_resp_time') do
      assert page.has_content?('Longest Response Time:')
      assert page.has_content?(40)
    end
  end

  def test_presents_shortest_response_time
    visit '/sources/jumpstartlab/urls/blog'
    within('#short_resp_time') do
      assert page.has_content?('Shortest Response Time:')
      assert page.has_content?(24)
    end
  end

  def test_presents_average_response_time
    visit '/sources/jumpstartlab/urls/blog'
    within('#avg_resp_time') do
      assert page.has_content?('Average Response Time:')
      assert page.has_content?(33.67)
    end
  end

  def test_presents_http_verbs
    visit '/sources/jumpstartlab/urls/blog'
    within('#http_verbs') do
      assert page.has_content?('HTTP Verbs Used:')
      assert page.has_content?('GET, PUT, POST')
    end
  end

  def test_presents_most_popular_referrers
    visit '/sources/jumpstartlab/urls/blog'
    within('#most_pop_refs') do
      assert page.has_content?('Most Popular Referrers:')
      assert page.has_content?("http://google.com")
    end
  end

  def test_presents_most_popular_user_agents
    visit '/sources/jumpstartlab/urls/blog'
    within('#most_pop_agents') do
      assert page.has_content?('Most Popular User Agents:')
      assert page.has_content?("Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    end
  end
end
