require 'test_helper'

class SmsMessagesControllerTest < ActionController::TestCase
  setup do
    @sms_message = sms_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sms_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sms_message" do
    assert_difference('SmsMessage.count') do
      post :create, sms_message: { event_time: @sms_message.event_time, sms_content: @sms_message.sms_content, sms_sender: @sms_message.sms_sender }
    end

    assert_redirected_to sms_message_path(assigns(:sms_message))
  end

  test "should show sms_message" do
    get :show, id: @sms_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sms_message
    assert_response :success
  end

  test "should update sms_message" do
    patch :update, id: @sms_message, sms_message: { event_time: @sms_message.event_time, sms_content: @sms_message.sms_content, sms_sender: @sms_message.sms_sender }
    assert_redirected_to sms_message_path(assigns(:sms_message))
  end

  test "should destroy sms_message" do
    assert_difference('SmsMessage.count', -1) do
      delete :destroy, id: @sms_message
    end

    assert_redirected_to sms_messages_path
  end
end
