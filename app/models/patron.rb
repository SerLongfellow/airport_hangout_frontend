class Patron
  attr_reader :id, :name, :hometown, :status

  def initialize(id, name, hometown, status="")
    @id = id
    @name = name
    @hometown = hometown 
    @status = status
  end

  def to_s()
    return "(#{id}) #{name} from #{hometown}"
  end

end
