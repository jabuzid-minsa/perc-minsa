require 'test_helper'

class ProductionUnitsControllerTest < ActionController::TestCase
  setup do
    @production_unit = production_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_unit" do
    assert_difference('ProductionUnit.count') do
      post :create, production_unit: { abbreviation: @production_unit.abbreviation, code: @production_unit.code, description: @production_unit.description, geography_id: @production_unit.geography_id, language_id: @production_unit.language_id, state: @production_unit.state }
    end

    assert_redirected_to production_unit_path(assigns(:production_unit))
  end

  test "should show production_unit" do
    get :show, id: @production_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_unit
    assert_response :success
  end

  test "should update production_unit" do
    patch :update, id: @production_unit, production_unit: { abbreviation: @production_unit.abbreviation, code: @production_unit.code, description: @production_unit.description, geography_id: @production_unit.geography_id, language_id: @production_unit.language_id, state: @production_unit.state }
    assert_redirected_to production_unit_path(assigns(:production_unit))
  end

  test "should destroy production_unit" do
    assert_difference('ProductionUnit.count', -1) do
      delete :destroy, id: @production_unit
    end

    assert_redirected_to production_units_path
  end
end
