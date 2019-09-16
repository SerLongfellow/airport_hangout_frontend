class LoungesRepository < ApplicationRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end

  def fetch_by_id(id)
    raise NoMethodError.new(not_implemented_error)
  end

  def update_patron_count(id, inc)
    raise NoMethodError.new(not_implemented_error)
  end

  def create(lounge)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryLoungesRepository < LoungesRepository
  @@initialized = false

  def initialize
    return if @@initialized

    @@lounges = []

    if ENV['RAILS_ENV'] == 'development'
      lounge = Lounge.new('1', 'Cool-Ass Playas Lounge', '1', 'Where all the cool kids come to play...', number_of_patrons=2)
      @@lounges.push(lounge)

      lounge = Lounge.new('2', 'I Want My IPA Lounge', '1', 'Over 9,000 IBU\'s!')
      @@lounges.push(lounge)

      lounge = Lounge.new('3', 'Delta Premium Lounge', '1', 'We\'re Delta...')
      @@lounges.push(lounge)

      lounge = Lounge.new('4', 'Whole Hog Barbeque', '2', description='Getcha some grub!')
      @@lounges.push(lounge)
    end

    @@initialized = true
  end

  def fetch_many(airport_id)
    result = @@lounges.select { |lounge| lounge.airport_id == airport_id }
    return result unless result.nil?
  end

  def fetch_by_id(lounge_id)
    result = @@lounges.find { |lounge| lounge.id == lounge_id }
    return result unless result.nil?

    raise NotFoundError, 'No lounge with ID ' + lounge_id
  end

  def update_patron_count(lounge_id, inc)
    lounge = fetch_by_id(lounge_id)
    return false if lounge.nil?

    lounge.number_of_patrons += inc
    lounge
  end

  def create(lounge)
    @@lounges.push(lounge)
  end

  def reset
    @@lounges = []
  end
end

class MemoryLoungesRepositoryFactory
  def self.create_repository
    MemoryLoungesRepository.instance
  end
end

class LoungesRepositoryFactory < ApplicationRepositoryFactory
  def self.repo_type
    :lounges
  end
end
