require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get restaurants_list_url
    assert_response :success
  end

  test "should get retrieve" do
    get restaurants_retrieve_url
    assert_response :success
  end

  test "should get create" do
    get restaurants_create_url
    assert_response :success
  end

  test "should get update" do
    get restaurants_update_url
    assert_response :success
  end

  test "should get destroy" do
    get restaurants_delete_url
    assert_response :success
  end

end
