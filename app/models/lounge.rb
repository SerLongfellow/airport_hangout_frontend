class Lounge 
  def initialize(id, name, airport, description="", number_of_patrons=0)
    @id = id
    @name = name
    @airport = airport
    @description = description
    @number_of_patrons = number_of_patrons
  end

  def id()
    @id
  end

  def name()
    @name
  end

  def airport()
    @airport
  end
  
  def description()
    @description
  end

  def number_of_patrons()
    @number_of_patrons
  end
end
