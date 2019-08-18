require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in
  end

  teardown do
    Rails.cache.clear
  end

  test "index" do
    get conversations_path
    assert_response :success
  end

  test "create good patron id" do
    post conversations_path(patron_id: "1")
    assert_response :redirect
  end
  
  test "create bad patron id" do
    post conversations_path(patron_id: "99")
    assert_response 400
  end
  
  test "show good convo id" do
    post conversations_path(patron_id: "1")
    assert_response :redirect
    follow_redirect!

    show_url = response.request.original_fullpath
    convo_id = show_url[show_url.rindex('/')+1, show_url.length]
    
    get conversation_path(convo_id)
    assert_response :success
  end
  
  test "show bad convo id" do
    get conversation_path('i_dont_exist')
    assert_response :missing
  end
end
