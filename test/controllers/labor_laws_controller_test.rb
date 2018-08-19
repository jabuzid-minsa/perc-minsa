require 'test_helper'

class LaborLawsControllerTest < ActionController::TestCase
  setup do
    @labor_law = labor_laws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:labor_laws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create labor_law" do
    assert_difference('LaborLaw.count') do
      post :create, labor_law: { contract_type_id: @labor_law.contract_type_id, entity_id: @labor_law.entity_id, extra_hours: @labor_law.extra_hours, festive_hours: @labor_law.festive_hours, hours_max: @labor_law.hours_max, labor_standard_id: @labor_law.labor_standard_id, max_extra_hours: @labor_law.max_extra_hours, max_festive_hours: @labor_law.max_festive_hours, min_wage: @labor_law.min_wage, month: @labor_law.month, staff_id: @labor_law.staff_id, year: @labor_law.year }
    end

    assert_redirected_to labor_law_path(assigns(:labor_law))
  end

  test "should show labor_law" do
    get :show, id: @labor_law
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @labor_law
    assert_response :success
  end

  test "should update labor_law" do
    patch :update, id: @labor_law, labor_law: { contract_type_id: @labor_law.contract_type_id, entity_id: @labor_law.entity_id, extra_hours: @labor_law.extra_hours, festive_hours: @labor_law.festive_hours, hours_max: @labor_law.hours_max, labor_standard_id: @labor_law.labor_standard_id, max_extra_hours: @labor_law.max_extra_hours, max_festive_hours: @labor_law.max_festive_hours, min_wage: @labor_law.min_wage, month: @labor_law.month, staff_id: @labor_law.staff_id, year: @labor_law.year }
    assert_redirected_to labor_law_path(assigns(:labor_law))
  end

  test "should destroy labor_law" do
    assert_difference('LaborLaw.count', -1) do
      delete :destroy, id: @labor_law
    end

    assert_redirected_to labor_laws_path
  end
end
