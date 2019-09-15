require 'test_helper'

class AirportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in
  end

  teardown do
    Rails.cache.clear
  end

  test "index" do
    get airports_path
    assert_response :success

    airports = assigns(:airports)
    assert_not_nil airports
  end
end
