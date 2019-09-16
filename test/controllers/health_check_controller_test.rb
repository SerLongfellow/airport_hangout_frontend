require 'test_helper'

class HealthCheckControllerTest < ActionDispatch::IntegrationTest
  test 'status returns 204' do
    get health_check_path
    assert_response :no_content
  end
end
