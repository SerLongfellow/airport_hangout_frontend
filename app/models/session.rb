class Session
  attr_reader :id, :current_user

  def initialize(id, current_user)
    @id = id
    @current_user = current_user
  end
end
