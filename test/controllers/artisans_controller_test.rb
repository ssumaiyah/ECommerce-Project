require "test_helper"

class ArtisansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get artisans_index_url
    assert_response :success
  end

  test "should get show" do
    get artisans_show_url
    assert_response :success
  end

  test "should get new" do
    get artisans_new_url
    assert_response :success
  end

  test "should get edit" do
    get artisans_edit_url
    assert_response :success
  end
end
