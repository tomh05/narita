require 'test_helper'

class AppNamesControllerTest < ActionController::TestCase
  setup do
    @app_name = app_names(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_name" do
    assert_difference('AppName.count') do
      post :create, app_name: { color: @app_name.color, longname: @app_name.longname, priority: @app_name.priority, shortname: @app_name.shortname }
    end

    assert_redirected_to app_name_path(assigns(:app_name))
  end

  test "should show app_name" do
    get :show, id: @app_name
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_name
    assert_response :success
  end

  test "should update app_name" do
    patch :update, id: @app_name, app_name: { color: @app_name.color, longname: @app_name.longname, priority: @app_name.priority, shortname: @app_name.shortname }
    assert_redirected_to app_name_path(assigns(:app_name))
  end

  test "should destroy app_name" do
    assert_difference('AppName.count', -1) do
      delete :destroy, id: @app_name
    end

    assert_redirected_to app_names_path
  end
end
