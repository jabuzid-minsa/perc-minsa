require 'test_helper'

class CareLevelsControllerTest < ActionController::TestCase
  setup do
    @care_level = care_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:care_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create care_level" do
    assert_difference('CareLevel.count') do
      post :create, care_level: { code: @care_level.code, description: @care_level.description, geography_id: @care_level.geography_id, language_id: @care_level.language_id, state: @care_level.state }
    end

    assert_redirected_to care_level_path(assigns(:care_level))
  end

  test "should show care_level" do
    get :show, id: @care_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @care_level
    assert_response :success
  end

  test "should update care_level" do
    patch :update, id: @care_level, care_level: { code: @care_level.code, description: @care_level.description, geography_id: @care_level.geography_id, language_id: @care_level.language_id, state: @care_level.state }
    assert_redirected_to care_level_path(assigns(:care_level))
  end

  test "should destroy care_level" do
    assert_difference('CareLevel.count', -1) do
      delete :destroy, id: @care_level
    end

    assert_redirected_to care_levels_path
  end
end
