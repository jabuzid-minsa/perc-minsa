require 'test_helper'

class AnalysisGraphsControllerTest < ActionController::TestCase
  test "should get management_number_one" do
    get :management_number_one
    assert_response :success
  end

end
