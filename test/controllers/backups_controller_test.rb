require 'test_helper'

class BackupsControllerTest < ActionController::TestCase
  setup do
    @backup = backups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create backup" do
    assert_difference('Backup.count') do
      post :create, backup: { ended: @backup.ended, ref: @backup.ref, started: @backup.started, username: @backup.username }
    end

    assert_redirected_to backup_path(assigns(:backup))
  end

  test "should show backup" do
    get :show, id: @backup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @backup
    assert_response :success
  end

  test "should update backup" do
    patch :update, id: @backup, backup: { ended: @backup.ended, ref: @backup.ref, started: @backup.started, username: @backup.username }
    assert_redirected_to backup_path(assigns(:backup))
  end

  test "should destroy backup" do
    assert_difference('Backup.count', -1) do
      delete :destroy, id: @backup
    end

    assert_redirected_to backups_path
  end
end
