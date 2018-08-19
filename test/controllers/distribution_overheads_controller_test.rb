require 'test_helper'

class DistributionOverheadsControllerTest < ActionController::TestCase
  setup do
    @distribution_overhead = distribution_overheads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distribution_overheads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distribution_overhead" do
    assert_difference('DistributionOverhead.count') do
      post :create, distribution_overhead: { cost_center_id: @distribution_overhead.cost_center_id, entity_id: @distribution_overhead.entity_id, general_value: @distribution_overhead.general_value, month: @distribution_overhead.month, supply_id: @distribution_overhead.supply_id, type_distribution_id: @distribution_overhead.type_distribution_id, value: @distribution_overhead.value, year: @distribution_overhead.year }
    end

    assert_redirected_to distribution_overhead_path(assigns(:distribution_overhead))
  end

  test "should show distribution_overhead" do
    get :show, id: @distribution_overhead
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distribution_overhead
    assert_response :success
  end

  test "should update distribution_overhead" do
    patch :update, id: @distribution_overhead, distribution_overhead: { cost_center_id: @distribution_overhead.cost_center_id, entity_id: @distribution_overhead.entity_id, general_value: @distribution_overhead.general_value, month: @distribution_overhead.month, supply_id: @distribution_overhead.supply_id, type_distribution_id: @distribution_overhead.type_distribution_id, value: @distribution_overhead.value, year: @distribution_overhead.year }
    assert_redirected_to distribution_overhead_path(assigns(:distribution_overhead))
  end

  test "should destroy distribution_overhead" do
    assert_difference('DistributionOverhead.count', -1) do
      delete :destroy, id: @distribution_overhead
    end

    assert_redirected_to distribution_overheads_path
  end
end
