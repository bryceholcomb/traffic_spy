require_relative "model_test_helper"
require 'traffic_spy/models/referral'

class ReferralTest < ModelTest
  def test_has_attributes
    referral = TrafficSpy::Referral.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal 1, referral.id
    assert_equal 'http://jumpstartlab.com/blog', referral.name
  end

  def test_find_or_create_by_returns_Referral_object_found_or_created
    referral1 = TrafficSpy::Referral.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    referral2 = TrafficSpy::Referral.find_or_create_by(:name, 'http://jumpstartlab.com/blog')
    assert_equal referral1.id, referral2.id
    assert_equal 1, TrafficSpy::Referral.all.count
  end
end
