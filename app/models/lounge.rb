class Lounge 
  attr_reader :id, :name, :airport, :description
  attr_accessor :number_of_patrons

  def initialize(id, name, airport, description="", number_of_patrons=0)
    @id = id
    @name = name
    @airport = airport
    @description = description
    @number_of_patrons = number_of_patrons
  end

  def to_s()
    return "#{id}) #{name}, #{number_of_patrons} patrons"
  end

end
