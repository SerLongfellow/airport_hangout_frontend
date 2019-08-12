class Patron
  def initialize(id, name, hometown)
    @id = id
    @name = name
    @hometown = hometown 
  end

  def to_s()
    return "#{id}) #{name} from #{hometown}"
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
end
