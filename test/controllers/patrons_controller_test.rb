require 'test_helper'

class PatronsControllerTest < ActionDispatch::IntegrationTest
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

  test "index good airport ID, good lounge ID" do
    get airport_lounge_patrons_path(@good_airport_id, @good_lounge_id)
    assert_response :success
  end
  
  test "index good airport ID, bad lounge ID" do
    get airport_lounge_patrons_path(@good_airport_id, @bad_lounge_id)
    assert_response :success
  end
  
  test "index bad airport ID, bad lounge ID" do
    get airport_lounge_patrons_path(@bad_airport_id, @bad_lounge_id)
    assert_response :success
  end
  
  test "create good airport ID, good lounge ID" do
    post airport_lounge_patrons_path(@good_airport_id, @good_lounge_id)
    assert_response :redirect
  end
  
  test "create good airport ID, bad lounge ID" do
    post airport_lounge_patrons_path(@good_airport_id, @bad_lounge_id)
    assert_response :missing
  end
  
  test "create bad airport ID, bad lounge ID" do
    post airport_lounge_patrons_path(@bad_airport_id, @bad_lounge_id)
    assert_response :missing
  end
  
  test "delete good airport ID, good lounge ID, good user_id" do
    delete airport_lounge_patron_path(@good_airport_id, @good_lounge_id, session[:current_user_id])
    assert_response :redirect
  end
  
  test "delete good airport ID, good lounge ID, bad user_id" do
    delete airport_lounge_patron_path(@good_airport_id, @good_lounge_id, 0)
    assert_response :missing
  end
  
  test "delete good airport ID, bad lounge ID, good user_id" do
    delete airport_lounge_patron_path(@good_airport_id, @bad_lounge_id, session[:current_user_id])
    assert_response :missing
  end
  
  test "delete bad airport ID, bad lounge ID, good_user_id" do
    delete airport_lounge_patron_path(@bad_airport_id, @bad_lounge_id, session[:current_user_id])
    assert_response :missing
  end
end
