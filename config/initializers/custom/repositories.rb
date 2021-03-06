
Rails.application.config.after_initialize do
  repo_loader = RepositoryLoader.new
  repo_loader.load_repositories
end

class RepositoryLoader
  def log(message)
    if Rails.application.config.log_level == :debug
      puts "[Repository Loader] " + message
    end
  end

  def load_repositories()
    repo_path = Rails.root.join('app', 'repositories')
    glob_path = repo_path.join('*')
    subdirs = Dir.glob(glob_path)

    load Rails.root.join('app', 'repositories', 'application_repository.rb')
    loaded_classes = get_loaded_classes
    
    subdirs.each do |dir|
      repo_files = Dir.glob(Pathname.new(dir).join('*_repository.rb'))
      repo_files.each do |f|
        load f
      end
    end
    
    post_file_loaded_classes = get_loaded_classes
    new_classes = post_file_loaded_classes - loaded_classes

    interfaces = get_interfaces(new_classes)
    interfaces.each do |interface|
      impls = get_implementations(interface, new_classes)
      repo_type = get_repo_type(interface)

      if Rails.application.config.x.repositories.nil? || Rails.application.config.x.repositories[repo_type.to_sym].nil?
        repo_impl = "Memory#{repo_type.capitalize}Repository"
        log("No repository implementation specified for #{repo_type}, defaulting to #{repo_impl}")
      else
        repo_impl = Rails.application.config.x.repositories[repo_type.to_sym]
        log("Configured #{repo_type} repository implementation is #{repo_impl}")
      end

      impl_factory = "#{repo_impl}Factory"
      impl_factory_class = post_file_loaded_classes.find { |klass| klass.to_s == impl_factory }

      if impl_factory_class.nil?
        log("Error! #{impl_factory} not found!")
        exit 1
      end
        
      ApplicationController.class_eval %Q(
        def create_#{repo_type}_repository
          #{impl_factory_class}.create_#{repo_type}_repository
        end
      )
    end 
  end

  def get_loaded_classes
    ObjectSpace.each_object(Class).to_a
  end

  def get_interfaces(classes)
    get_implementations(ApplicationRepository, classes)
  end
  
  def get_implementations(interface, classes)
    classes.select { |klass| klass.superclass == interface }
  end

  def get_repo_type(klass)
    m = /(.*)Repository/.match(klass.to_s)
    return nil if m.nil?
    return m.captures[0].downcase
  end
end
