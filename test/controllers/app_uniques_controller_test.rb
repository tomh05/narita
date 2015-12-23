require 'test_helper'

class AppUniquesControllerTest < ActionController::TestCase
  setup do
    @app_unique = app_uniques(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_uniques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_unique" do
    assert_difference('AppUnique.count') do
      post :create, app_unique: { app_name: @app_unique.app_name, event_time: @app_unique.event_time, event_type: @app_unique.event_type, username: @app_unique.username }
    end

    assert_redirected_to app_unique_path(assigns(:app_unique))
  end

  test "should show app_unique" do
    get :show, id: @app_unique
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_unique
    assert_response :success
  end

  test "should update app_unique" do
    patch :update, id: @app_unique, app_unique: { app_name: @app_unique.app_name, event_time: @app_unique.event_time, event_type: @app_unique.event_type, username: @app_unique.username }
    assert_redirected_to app_unique_path(assigns(:app_unique))
  end

  test "should destroy app_unique" do
    assert_difference('AppUnique.count', -1) do
      delete :destroy, id: @app_unique
    end

    assert_redirected_to app_uniques_path
  end
end
