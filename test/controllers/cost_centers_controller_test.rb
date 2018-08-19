require 'test_helper'

class CostCentersControllerTest < ActionController::TestCase
  setup do
    @cost_center = cost_centers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cost_centers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cost_center" do
    assert_difference('CostCenter.count') do
      post :create, cost_center: { code: @cost_center.code, cost_center_id: @cost_center.cost_center_id, cost_distribution_id: @cost_center.cost_distribution_id, description: @cost_center.description, function: @cost_center.function, geography_id: @cost_center.geography_id, language_id: @cost_center.language_id, staff_id: @cost_center.staff_id, state: @cost_center.state, supply_id: @cost_center.supply_id }
    end

    assert_redirected_to cost_center_path(assigns(:cost_center))
  end

  test "should show cost_center" do
    get :show, id: @cost_center
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cost_center
    assert_response :success
  end

  test "should update cost_center" do
    patch :update, id: @cost_center, cost_center: { code: @cost_center.code, cost_center_id: @cost_center.cost_center_id, cost_distribution_id: @cost_center.cost_distribution_id, description: @cost_center.description, function: @cost_center.function, geography_id: @cost_center.geography_id, language_id: @cost_center.language_id, staff_id: @cost_center.staff_id, state: @cost_center.state, supply_id: @cost_center.supply_id }
    assert_redirected_to cost_center_path(assigns(:cost_center))
  end

  test "should destroy cost_center" do
    assert_difference('CostCenter.count', -1) do
      delete :destroy, id: @cost_center
    end

    assert_redirected_to cost_centers_path
  end
end
