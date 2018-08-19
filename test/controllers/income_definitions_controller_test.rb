require 'test_helper'

class IncomeDefinitionsControllerTest < ActionController::TestCase
  setup do
    @income_definition = income_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:income_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create income_definition" do
    assert_difference('IncomeDefinition.count') do
      post :create, income_definition: { cost_center_id: @income_definition.cost_center_id, entity_id: @income_definition.entity_id, invoice: @income_definition.invoice }
    end

    assert_redirected_to income_definition_path(assigns(:income_definition))
  end

  test "should show income_definition" do
    get :show, id: @income_definition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @income_definition
    assert_response :success
  end

  test "should update income_definition" do
    patch :update, id: @income_definition, income_definition: { cost_center_id: @income_definition.cost_center_id, entity_id: @income_definition.entity_id, invoice: @income_definition.invoice }
    assert_redirected_to income_definition_path(assigns(:income_definition))
  end

  test "should destroy income_definition" do
    assert_difference('IncomeDefinition.count', -1) do
      delete :destroy, id: @income_definition
    end

    assert_redirected_to income_definitions_path
  end
end
