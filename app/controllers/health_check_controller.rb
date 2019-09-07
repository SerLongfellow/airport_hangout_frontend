class HealthCheckController < ActionController::Base
  def status
    # return 204
    head :no_content
  end
end
