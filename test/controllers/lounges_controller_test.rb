require 'test_helper'

class LoungesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in
    @good_airport_id = '1'
    @bad_airport_id = '99'

    @good_lounge_id = '1'
    @bad_lounge_id = '99'

    @repo = LoungesRepositoryFactory.create_repository
    @lounge1 = Lounge.new(@good_lounge_id, 'Test Lounge', @good_airport_id, "Test Lounge Desc", 4)
    @repo.create(@lounge1)
  end

  teardown do
    Rails.cache.clear
    @repo.reset
  end

  test 'index good airport ID' do
    get airport_lounges_path(@good_airport_id)
    assert_response :success

    lounges = assigns(:lounges)
    assert_equal(1, lounges.count)
    assert_equal(@lounge1, lounges.first)
  end

  test 'index bad airport ID' do
    get airport_lounges_path(@bad_airport_id)
    assert_response :success

    lounges = assigns(:lounges)
    assert_equal(0, lounges.count)
  end

  test 'show good lounge ID' do
    get lounge_path(@good_lounge_id)
    assert_response :success

    lounge = assigns(:lounge)
    assert_equal(@lounge1, lounge)
  end

  test 'show bad lounge ID' do
    get lounge_path(@bad_lounge_id)
    assert_response :missing
  end
end
