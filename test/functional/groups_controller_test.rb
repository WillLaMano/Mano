require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

end
