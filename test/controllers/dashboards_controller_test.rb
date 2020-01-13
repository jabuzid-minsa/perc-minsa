require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  test "should get main_dashboard" do
    get :main_dashboard
    assert_response :success
  end

end
