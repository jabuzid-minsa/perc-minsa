require 'test_helper'

class SuppliesCategoriesControllerTest < ActionController::TestCase
  setup do
    @supplies_category = supplies_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supplies_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplies_category" do
    assert_difference('SuppliesCategory.count') do
      post :create, supplies_category: { code: @supplies_category.code, description: @supplies_category.description, geography_id: @supplies_category.geography_id, language_id: @supplies_category.language_id, state: @supplies_category.state }
    end

    assert_redirected_to supplies_category_path(assigns(:supplies_category))
  end

  test "should show supplies_category" do
    get :show, id: @supplies_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supplies_category
    assert_response :success
  end

  test "should update supplies_category" do
    patch :update, id: @supplies_category, supplies_category: { code: @supplies_category.code, description: @supplies_category.description, geography_id: @supplies_category.geography_id, language_id: @supplies_category.language_id, state: @supplies_category.state }
    assert_redirected_to supplies_category_path(assigns(:supplies_category))
  end

  test "should destroy supplies_category" do
    assert_difference('SuppliesCategory.count', -1) do
      delete :destroy, id: @supplies_category
    end

    assert_redirected_to supplies_categories_path
  end
end
