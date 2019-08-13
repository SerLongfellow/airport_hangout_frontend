class Airport
  attr_reader :id, :code, :name

  def initialize(id, code, name)
    @id = id
    @code = code
    @name = name
  end
end
