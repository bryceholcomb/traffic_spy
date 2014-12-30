require_relative "../test_helper"
require_relative "../../lib/traffic_spy"

Capybara.app = TrafficSpy::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    # call delete_all on database?
  end
end
