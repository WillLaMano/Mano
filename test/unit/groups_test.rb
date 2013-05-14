require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  
  test "name needs to be present" do
    group = FactoryGirl.build(:group)
    group.name = nil
    group.valid?
    assert group.errors["name"].include?("can't be blank")
  end
  
  test "the factory works" do
    group = FactoryGirl.create(:group)
    assert group.valid?
  end
  
end
