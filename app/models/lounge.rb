class Lounge 
  attr_reader :id, :name, :airport_id, :description
  attr_accessor :number_of_patrons

  def initialize(id, name, airport_id, description = '', number_of_patrons = 0)
    @id = id
    @name = name
    @airport_id = airport_id
    @description = description
    @number_of_patrons = number_of_patrons
  end

  def to_s
    "#{id}) #{name}, #{number_of_patrons} patrons"
  end

end
