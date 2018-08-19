require 'test_helper'

class DistributionSuppliesControllerTest < ActionController::TestCase
  setup do
    @distribution_supply = distribution_supplies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distribution_supplies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distribution_supply" do
    assert_difference('DistributionSupply.count') do
      post :create, distribution_supply: { cost_center_id: @distribution_supply.cost_center_id, entity_id: @distribution_supply.entity_id, month: @distribution_supply.month, supply_id: @distribution_supply.supply_id, value: @distribution_supply.value, year: @distribution_supply.year }
    end

    assert_redirected_to distribution_supply_path(assigns(:distribution_supply))
  end

  test "should show distribution_supply" do
    get :show, id: @distribution_supply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distribution_supply
    assert_response :success
  end

  test "should update distribution_supply" do
    patch :update, id: @distribution_supply, distribution_supply: { cost_center_id: @distribution_supply.cost_center_id, entity_id: @distribution_supply.entity_id, month: @distribution_supply.month, supply_id: @distribution_supply.supply_id, value: @distribution_supply.value, year: @distribution_supply.year }
    assert_redirected_to distribution_supply_path(assigns(:distribution_supply))
  end

  test "should destroy distribution_supply" do
    assert_difference('DistributionSupply.count', -1) do
      delete :destroy, id: @distribution_supply
    end

    assert_redirected_to distribution_supplies_path
  end
end
