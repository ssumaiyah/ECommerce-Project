require "test_helper"

class ProductCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get product_categories_index_url
    assert_response :success
  end

  test "should get show" do
    get product_categories_show_url
    assert_response :success
  end

  test "should get new" do
    get product_categories_new_url
    assert_response :success
  end

  test "should get edit" do
    get product_categories_edit_url
    assert_response :success
  end
end
