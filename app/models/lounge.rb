class Lounge 
  def initialize(id, name, airport, number_of_patrons=0)
    @id = id
    @name = name
    @airport = airport
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

  def number_of_patrons()
    @number_of_patrons
  end
end
