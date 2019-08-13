require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new session" do
    sign_in()

    assert_not_nil session[:current_user_id]
    assert_response :redirect
    assert_redirected_to home_index_path
  end
end
