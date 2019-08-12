
require 'repositories/application_repository'
require 'repositories/lounges/lounges_repository'


class PatronsRepository < ApplicationRepository
  def fetch_many(lounge_id, current_patron_id)
    raise NoMethodError.new(not_implemented_error())
  end

  def check_into_lounge(lounge_id, patron_id)
    raise NoMethodError.new(not_implemented_error())
  end

end

class MemoryPatronsRepository < PatronsRepository

  @@initialized = false
  
  def initialize(lounge_repo_class=MemoryLoungesRepository)
    @lounge_repo = lounge_repo_class.new

    return if @@initialized

    @@lounge_patrons = []

    patrons_list = []
    patrons_list.push(Patron.new(1, "Billy Bob", "Little Rock, AR"))
    patrons_list.push(Patron.new(2, "Foo Bar", "Seattle, WA"))
    @@lounge_patrons.push(patrons_list)

    patrons_list = []
    @@lounge_patrons.push(patrons_list)
    
    patrons_list = []
    @@lounge_patrons.push(patrons_list)

    @@initialized = true
  end

  def fetch_many(lounge_id, current_patron_id)
    result = []
    
    lounge_patrons = @@lounge_patrons[lounge_id.to_i - 1]
    return result if lounge_patrons.nil?
    
    lounge_patrons.select do |patron|
      if patron.id != current_patron_id
        result.push(patron)
      else
        result.push(Patron.new(patron.id, "You", patron.hometown))
      end
    end

    return result
  end
  
  def check_into_lounge(airport_id, lounge_id, user)
    lounge_patrons = fetch_many(lounge_id, user.id)

    if !lounge_patrons.nil?
      lounge_patrons.push(Patron.new(user.id, user.name, user.hometown))

      @lounge_repo.update_patron_count(airport_id, lounge_id, 1)
      @@lounge_patrons[lounge_id.to_i - 1] = lounge_patrons

      return true
    else
      return false
    end
  end
  
  def leave_lounge(airport_id, lounge_id, user)
    lounge_patrons = fetch_many(lounge_id, user.id)

    if !lounge_patrons.nil?
      lounge_patrons = lounge_patrons.reject! {|patron| patron.id == user.id}

      if lounge_patrons.nil?
        return false
      end
      
      @lounge_repo.update_patron_count(airport_id, lounge_id, -1)
      @@lounge_patrons[lounge_id.to_i - 1] = lounge_patrons

      return true
    else
      return false
    end
  end
end
