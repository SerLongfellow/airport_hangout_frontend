class User
  def initialize(id, name, hometown, current_lounge=nil)
    @id = id
    @name = name
    @hometown = hometown 
    @current_lounge = current_lounge
  end

  def id()
    @id
  end

  def name()
    @name
  end

  def hometown()
    @hometown
  end
  
  def current_lounge()
    @current_lounge
  end
  
  def current_lounge=(lounge)
    @current_lounge = lounge
  end
end
