namespace :roles do

  desc 'Create default roles'
  task :create_defaults => :environment do
    Role.create([
                  { :name => 'super_admin' },
                  { :name => "admin" },
                  { :name => 'site_manager' },
                  { :name => 'customer_manager' }
                ])
  end

end