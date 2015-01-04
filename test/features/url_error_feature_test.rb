require_relative "feature_test_helper"

class UrlErrorFeatureTest < FeatureTest
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
    post '/sources/jumpstartlab/data', @payload1
  end

  def test_it_shows_error_page_when_url_doesnt_exist
    visit '/sources/jumpstartlab/urls/article'
    within('h2') do
      assert page.has_content?('This URL has not been requested')
    end
  end
end
