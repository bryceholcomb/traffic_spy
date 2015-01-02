require_relative "../test_helper"
require_relative "../../lib/traffic_spy"

class ModelTest < Minitest::Test
  def teardown
    TrafficSpy::DB.from(:urls).delete
    TrafficSpy::DB.from(:sources).delete
    TrafficSpy::DB.from(:data).delete
    TrafficSpy::DB.from(:referrals).delete
    TrafficSpy::DB.from(:events).delete
    TrafficSpy::DB.from(:user_agents).delete
    TrafficSpy::DB.from(:resolutions).delete
    TrafficSpy::DB.from(:sqlite_sequence).delete
  end
end
