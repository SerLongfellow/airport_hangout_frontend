require 'singleton'

class ApplicationRepository
  include Singleton
  require_relative '../errors/application_errors'

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end

class ApplicationRepositoryFactory
  def self.create_repository
    Rails.application.config.x.repository_factories[repo_type].create_repository
  end

  def self.repo_type
    raise NoMethodError("'repo_type' method must be overridden by including module")
  end
end
