require 'test_helper'

class CostDistributionsControllerTest < ActionController::TestCase
  setup do
    @cost_distribution = cost_distributions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cost_distributions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cost_distribution" do
    assert_difference('CostDistribution.count') do
      post :create, cost_distribution: { code: @cost_distribution.code, description: @cost_distribution.description, geography_id: @cost_distribution.geography_id, language_id: @cost_distribution.language_id, state: @cost_distribution.state }
    end

    assert_redirected_to cost_distribution_path(assigns(:cost_distribution))
  end

  test "should show cost_distribution" do
    get :show, id: @cost_distribution
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cost_distribution
    assert_response :success
  end

  test "should update cost_distribution" do
    patch :update, id: @cost_distribution, cost_distribution: { code: @cost_distribution.code, description: @cost_distribution.description, geography_id: @cost_distribution.geography_id, language_id: @cost_distribution.language_id, state: @cost_distribution.state }
    assert_redirected_to cost_distribution_path(assigns(:cost_distribution))
  end

  test "should destroy cost_distribution" do
    assert_difference('CostDistribution.count', -1) do
      delete :destroy, id: @cost_distribution
    end

    assert_redirected_to cost_distributions_path
  end
end
