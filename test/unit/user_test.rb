require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  test "that there cannot be duplicate emails" do
    FactoryGirl.create(:user, :email => 'thomas@wdpk837.com')
    assert_raise(ActiveRecord::RecordInvalid) {FactoryGirl.create(:user, :email => 'thomas@wdpk837.com')}
  end
end
