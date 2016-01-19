require 'test_helper'

class WhatsappMessagesControllerTest < ActionController::TestCase
  setup do
    @whatsapp_message = whatsapp_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:whatsapp_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create whatsapp_message" do
    assert_difference('WhatsappMessage.count') do
      post :create, whatsapp_message: { message_type: @whatsapp_message.message_type, stack_level: @whatsapp_message.stack_level, username: @whatsapp_message.username, wa_content: @whatsapp_message.wa_content, wa_date: @whatsapp_message.wa_date, wa_from: @whatsapp_message.wa_from }
    end

    assert_redirected_to whatsapp_message_path(assigns(:whatsapp_message))
  end

  test "should show whatsapp_message" do
    get :show, id: @whatsapp_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @whatsapp_message
    assert_response :success
  end

  test "should update whatsapp_message" do
    patch :update, id: @whatsapp_message, whatsapp_message: { message_type: @whatsapp_message.message_type, stack_level: @whatsapp_message.stack_level, username: @whatsapp_message.username, wa_content: @whatsapp_message.wa_content, wa_date: @whatsapp_message.wa_date, wa_from: @whatsapp_message.wa_from }
    assert_redirected_to whatsapp_message_path(assigns(:whatsapp_message))
  end

  test "should destroy whatsapp_message" do
    assert_difference('WhatsappMessage.count', -1) do
      delete :destroy, id: @whatsapp_message
    end

    assert_redirected_to whatsapp_messages_path
  end
end
