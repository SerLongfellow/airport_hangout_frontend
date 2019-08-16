class User
  attr_reader :name, :hometown
  attr_accessor :id, :current_lounge

  def initialize(id, name, hometown, current_lounge=nil)
    @id = id
    @name = name
    @hometown = hometown 
    @current_lounge = current_lounge
  end

  def to_s
    "user_" + @id
  end
end
