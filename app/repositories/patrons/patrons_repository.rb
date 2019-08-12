
require 'repositories/application_repository'

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
  
  def initialize()
    if @@initialized
      return
    end

    puts "Creating new patrons repo"
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
    lounge = @@lounge_patrons[lounge_id.to_i - 1].select do |patron|
      patron.id != current_patron_id
    end

    return lounge
  end
  
  def check_into_lounge(lounge_id, patron_id)
    lounge = fetch_many(lounge_id, patron_id)

    if !lounge.nil?
      lounge.push(Patron.new(patron_id, "New Patron", "Tacoma, WA"))
      return true
    else
      return false
    end
  end
  
  def leave_lounge(lounge_id, patron_id)
    lounge = fetch_many(lounge_id, patron_id)

    if !lounge.nil?
      lounge.delete_if {|patron| patron.id = patron_id}
      return true
    else
      return false
    end
  end
end
