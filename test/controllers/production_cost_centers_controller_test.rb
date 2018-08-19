require 'test_helper'

class ProductionCostCentersControllerTest < ActionController::TestCase
  setup do
    @production_cost_center = production_cost_centers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_cost_centers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_cost_center" do
    assert_difference('ProductionCostCenter.count') do
      post :create, production_cost_center: { cost_center_id: @production_cost_center.cost_center_id, entity_id: @production_cost_center.entity_id, month: @production_cost_center.month, production_units: @production_cost_center.production_units, value: @production_cost_center.value, year: @production_cost_center.year }
    end

    assert_redirected_to production_cost_center_path(assigns(:production_cost_center))
  end

  test "should show production_cost_center" do
    get :show, id: @production_cost_center
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_cost_center
    assert_response :success
  end

  test "should update production_cost_center" do
    patch :update, id: @production_cost_center, production_cost_center: { cost_center_id: @production_cost_center.cost_center_id, entity_id: @production_cost_center.entity_id, month: @production_cost_center.month, production_units: @production_cost_center.production_units, value: @production_cost_center.value, year: @production_cost_center.year }
    assert_redirected_to production_cost_center_path(assigns(:production_cost_center))
  end

  test "should destroy production_cost_center" do
    assert_difference('ProductionCostCenter.count', -1) do
      delete :destroy, id: @production_cost_center
    end

    assert_redirected_to production_cost_centers_path
  end
end
