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

  def test_it_returns_a_400_status_and_error_message_with_missing_params
    post '/sources', {"identifier" => "jumpstartlab"}
    assert_equal 400, last_response.status

    post '/sources', {"rootUrl" => "http://jumpstartlab.com"}
    assert_equal 400, last_response.status
    assert_equal "Missing params", last_response.body

  end
end
