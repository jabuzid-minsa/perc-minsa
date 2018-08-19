require 'test_helper'

class ProgrammingHoursControllerTest < ActionController::TestCase
  setup do
    @programming_hour = programming_hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:programming_hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create programming_hour" do
    assert_difference('ProgrammingHour.count') do
      post :create, programming_hour: { cost_center_id: @programming_hour.cost_center_id, entity_id: @programming_hour.entity_id, hours: @programming_hour.hours, month: @programming_hour.month, paid: @programming_hour.paid, payroll_id: @programming_hour.payroll_id, total: @programming_hour.total, year: @programming_hour.year }
    end

    assert_redirected_to programming_hour_path(assigns(:programming_hour))
  end

  test "should show programming_hour" do
    get :show, id: @programming_hour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @programming_hour
    assert_response :success
  end

  test "should update programming_hour" do
    patch :update, id: @programming_hour, programming_hour: { cost_center_id: @programming_hour.cost_center_id, entity_id: @programming_hour.entity_id, hours: @programming_hour.hours, month: @programming_hour.month, paid: @programming_hour.paid, payroll_id: @programming_hour.payroll_id, total: @programming_hour.total, year: @programming_hour.year }
    assert_redirected_to programming_hour_path(assigns(:programming_hour))
  end

  test "should destroy programming_hour" do
    assert_difference('ProgrammingHour.count', -1) do
      delete :destroy, id: @programming_hour
    end

    assert_redirected_to programming_hours_path
  end
end
