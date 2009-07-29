namespace :db do
  namespace :roles do
    desc 'Create default roles'
    task :create_defaults => :environment do
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Creating default roles..."
      Role.create([
                    { :name => 'super_admin' },
                    { :name => "admin" },
                    { :name => 'site_manager' },
                    { :name => 'customer_manager' }
                  ])
      puts "Default roles created successfully"
    end
  end
end