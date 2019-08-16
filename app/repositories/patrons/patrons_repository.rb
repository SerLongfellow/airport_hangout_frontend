
require 'repositories/application_repository'
require 'repositories/lounges/lounges_repository'


class PatronsRepository < ApplicationRepository
  def fetch_many(lounge_id, current_user_id)
    raise NoMethodError.new(not_implemented_error())
  end
  
  def fetch_by_id(patron_id)
    raise NoMethodError.new(not_implemented_error())
  end

  def check_into_lounge(lounge_id, current_user_id)
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
    patrons_list.push(Patron.new("1", "Billy Bob", "Little Rock, AR", status="Watching Monster Jam! Yeehaw!"))
    patrons_list.push(Patron.new("2", "Foo Bar", "Seattle, WA", status="Enjoying some beers - come chat!"))
    @@lounge_patrons.push(patrons_list)

    patrons_list = []
    @@lounge_patrons.push(patrons_list)
    
    patrons_list = []
    @@lounge_patrons.push(patrons_list)

    @@initialized = true
  end

  def fetch_many(lounge_id, current_user_id)
    result = []
    
    lounge_patrons = @@lounge_patrons[lounge_id.to_i - 1]
    return result if lounge_patrons.nil?
    
    lounge_patrons.each do |patron|
      if patron.id != current_user_id
        result.push(patron)
      end
    end

    return result
  end

  def fetch_by_id(patron_id)
    @@lounge_patrons.each do |lounge|
      lounge.each do |patron|
        return patron if patron.id == patron_id
      end
    end

    raise RepositoryErrors::NotFoundError.new("No patron found with ID #{patron_id}")
  end
  
  def check_into_lounge(lounge_id, user)
    lounge_patrons = fetch_many(lounge_id, user.id)

    if !lounge_patrons.nil?
      lounge_patrons.push(Patron.new(user.id, user.name, user.hometown))

      @lounge_repo.update_patron_count(lounge_id, 1)
      @@lounge_patrons[lounge_id.to_i - 1] = lounge_patrons

      return true
    else
      return false
    end
  end
  
  def leave_lounge(lounge_id, user)
    lounge_patrons = fetch_many(lounge_id, user.id)

    if !lounge_patrons.nil?
      lounge_patrons = lounge_patrons.reject! {|patron| patron.id == user.id}

      if lounge_patrons.nil?
        return false
      end
      
      @lounge_repo.update_patron_count(lounge_id, -1)
      @@lounge_patrons[lounge_id.to_i - 1] = lounge_patrons

      return true
    else
      return false
    end
  end
end
