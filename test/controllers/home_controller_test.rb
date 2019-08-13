require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  test "default landing redirect new session" do
    get home_index_path
    
    assert_response :redirect
    assert_redirected_to new_session_path
  end

  test "default landing existing session index" do
    sign_in()

    assert_response :redirect
    assert_redirected_to home_index_path
  end
end
