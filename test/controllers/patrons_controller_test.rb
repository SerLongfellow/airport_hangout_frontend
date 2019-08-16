require 'test_helper'

class PatronsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in()
    @good_lounge_id = "1"
    @bad_lounge_id = "99"
  end

  teardown do
    Rails.cache.clear
  end

  test "index good lounge ID" do
    get lounge_patrons_path(@good_lounge_id)
    assert_response :success
  end
  
  test "index bad lounge ID" do
    get lounge_patrons_path(@bad_lounge_id)
    assert_response :success
  end
  
  test "create good lounge ID" do
    post lounge_patrons_path(@good_lounge_id)
    assert_response :redirect
  end
  
  test "create bad lounge ID" do
    post lounge_patrons_path(@bad_lounge_id)
    assert_response :missing
  end
  
  test "delete good lounge ID" do
    delete lounge_patronage_path(@good_lounge_id)
    assert_response :redirect
  end
  
  test "delete bad lounge ID" do
    delete lounge_patronage_path(@bad_lounge_id)
    assert_response :missing
  end
  
end
