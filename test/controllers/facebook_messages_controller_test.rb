require 'test_helper'

class FacebookMessagesControllerTest < ActionController::TestCase
  setup do
    @facebook_message = facebook_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facebook_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facebook_message" do
    assert_difference('FacebookMessage.count') do
      post :create, facebook_message: { fb_content: @facebook_message.fb_content, fb_date: @facebook_message.fb_date, fb_from: @facebook_message.fb_from, username: @facebook_message.username }
    end

    assert_redirected_to facebook_message_path(assigns(:facebook_message))
  end

  test "should show facebook_message" do
    get :show, id: @facebook_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @facebook_message
    assert_response :success
  end

  test "should update facebook_message" do
    patch :update, id: @facebook_message, facebook_message: { fb_content: @facebook_message.fb_content, fb_date: @facebook_message.fb_date, fb_from: @facebook_message.fb_from, username: @facebook_message.username }
    assert_redirected_to facebook_message_path(assigns(:facebook_message))
  end

  test "should destroy facebook_message" do
    assert_difference('FacebookMessage.count', -1) do
      delete :destroy, id: @facebook_message
    end

    assert_redirected_to facebook_messages_path
  end
end
