class User
  attr_reader :id, :name, :hometown
  attr_accessor :current_lounge

  def initialize(id, name, hometown, current_lounge=nil)
    @id = id
    @name = name
    @hometown = hometown 
    @current_lounge = current_lounge
  end
end
