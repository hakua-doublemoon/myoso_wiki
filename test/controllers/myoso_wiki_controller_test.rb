require 'test_helper'

class MyosoWikiControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get home_main" do
    get :home_main
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get mw_fileio" do
    get :mw_fileio
    assert_response :success
  end

  test "should get menu" do
    get :menu
    assert_response :success
  end

  test "should get menu_list" do
    get :menu_list
    assert_response :success
  end

end
