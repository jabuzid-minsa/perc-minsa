require 'test_helper'

class DistributionAreasControllerTest < ActionController::TestCase
  setup do
    @distribution_area = distribution_areas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distribution_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distribution_area" do
    assert_difference('DistributionArea.count') do
      post :create, distribution_area: { cost_center_id: @distribution_area.cost_center_id, entity_id: @distribution_area.entity_id, meters: @distribution_area.meters, month: @distribution_area.month, year: @distribution_area.year }
    end

    assert_redirected_to distribution_area_path(assigns(:distribution_area))
  end

  test "should show distribution_area" do
    get :show, id: @distribution_area
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distribution_area
    assert_response :success
  end

  test "should update distribution_area" do
    patch :update, id: @distribution_area, distribution_area: { cost_center_id: @distribution_area.cost_center_id, entity_id: @distribution_area.entity_id, meters: @distribution_area.meters, month: @distribution_area.month, year: @distribution_area.year }
    assert_redirected_to distribution_area_path(assigns(:distribution_area))
  end

  test "should destroy distribution_area" do
    assert_difference('DistributionArea.count', -1) do
      delete :destroy, id: @distribution_area
    end

    assert_redirected_to distribution_areas_path
  end
end
