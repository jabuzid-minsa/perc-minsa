require 'test_helper'

class PayrollsControllerTest < ActionController::TestCase
  setup do
    @payroll = payrolls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payrolls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payroll" do
    assert_difference('Payroll.count') do
      post :create, payroll: { dni: @payroll.dni, entity_id: @payroll.entity_id, labor_law_id: @payroll.labor_law_id, name: @payroll.name, salary: @payroll.salary }
    end

    assert_redirected_to payroll_path(assigns(:payroll))
  end

  test "should show payroll" do
    get :show, id: @payroll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payroll
    assert_response :success
  end

  test "should update payroll" do
    patch :update, id: @payroll, payroll: { dni: @payroll.dni, entity_id: @payroll.entity_id, labor_law_id: @payroll.labor_law_id, name: @payroll.name, salary: @payroll.salary }
    assert_redirected_to payroll_path(assigns(:payroll))
  end

  test "should destroy payroll" do
    assert_difference('Payroll.count', -1) do
      delete :destroy, id: @payroll
    end

    assert_redirected_to payrolls_path
  end
end
