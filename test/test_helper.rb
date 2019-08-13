ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase

  def sign_in()
    post sessions_url, params: { name: "Test User", hometown: "Seattle, WA" }
  end
end
