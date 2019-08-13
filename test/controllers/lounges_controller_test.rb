require 'test_helper'

class LoungesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in()
    @good_airport_id = "1"
    @bad_airport_id = "99"
    
    @good_lounge_id = "1"
    @bad_lounge_id = "99"
  end

  teardown do
    Rails.cache.clear
  end

  test "index good airport ID" do
    get airport_lounges_path(@good_airport_id)
    assert_response :success
  end
  
  test "index bad airport ID" do
    get airport_lounges_path(@bad_airport_id)
    assert_response :missing
  end
  
  test "show good airport ID and good lounge ID" do
    get airport_lounge_path(@good_airport_id, @good_lounge_id)
    assert_response :success
  end
  
  test "show good airport ID and bad lounge ID" do
    get airport_lounge_path(@good_airport_id, @bad_lounge_id)
    assert_response :missing
  end
  
  test "show bad airport ID and bad lounge ID" do
    get airport_lounge_path(@bad_airport_id, @bad_lounge_id)
    assert_response :missing
  end
end
