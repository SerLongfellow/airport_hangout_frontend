require 'test_helper'

class AirportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in

    @repo = AirportsRepositoryFactory.create_repository

    @airport1 = Airport.new(1, 'TST', 'Test Airport')
    @repo.create(@airport1)
  end

  teardown do
    Rails.cache.clear
    @repo.reset
  end

  test 'index with one airport' do
    get airports_path
    assert_response :success

    airports = assigns(:airports)
    assert_not_nil airports
    assert_equal(1, airports.count)
    assert_equal(@airport1, airports.first)

    selected_airport = assigns(:selected_airport)
    assert_not_nil selected_airport
    assert_equal(@airport1, selected_airport)
  end

  test 'index with multiple airport' do
    airport2 = Airport.new('2', 'TST2', 'Test Airport 2')
    @repo.create(airport2)

    get airports_path
    assert_response :success

    airports = assigns(:airports)
    assert_not_nil airports
    assert_equal(2, airports.count)
    assert_equal(@airport1, airports.first)
    assert_equal(airport2, airports.last)

    selected_airport = assigns(:selected_airport)
    assert_not_nil selected_airport
    assert_equal(@airport1, selected_airport)
  end
end
