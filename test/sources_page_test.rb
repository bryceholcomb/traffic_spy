require_relative "test_helper"

class SourcesPageTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_user_can_create_an_identifier_and_rootUrl
    post '/sources', {"identifier" => "jumpstartlab", "rootUrl" => "http://jumpstartlab.com"}
    assert last_response.ok?
    assert_equal '{"identifier":"jumpstartlab"}', last_response.body
  end
end
