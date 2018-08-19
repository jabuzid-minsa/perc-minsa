require 'test_helper'

class DistributionCostsControllerTest < ActionController::TestCase
  setup do
    @distribution_cost = distribution_costs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distribution_costs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distribution_cost" do
    assert_difference('DistributionCost.count') do
      post :create, distribution_cost: { cost_center_id: @distribution_cost.cost_center_id, entity_id: @distribution_cost.entity_id, month: @distribution_cost.month, supported_cost_center_id: @distribution_cost.supported_cost_center_id, value: @distribution_cost.value, year: @distribution_cost.year }
    end

    assert_redirected_to distribution_cost_path(assigns(:distribution_cost))
  end

  test "should show distribution_cost" do
    get :show, id: @distribution_cost
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distribution_cost
    assert_response :success
  end

  test "should update distribution_cost" do
    patch :update, id: @distribution_cost, distribution_cost: { cost_center_id: @distribution_cost.cost_center_id, entity_id: @distribution_cost.entity_id, month: @distribution_cost.month, supported_cost_center_id: @distribution_cost.supported_cost_center_id, value: @distribution_cost.value, year: @distribution_cost.year }
    assert_redirected_to distribution_cost_path(assigns(:distribution_cost))
  end

  test "should destroy distribution_cost" do
    assert_difference('DistributionCost.count', -1) do
      delete :destroy, id: @distribution_cost
    end

    assert_redirected_to distribution_costs_path
  end
end
