namespace :db do

  desc 'Bootstrap the database'
  task :bootstrap => :environment do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:rebuild"].invoke
  end

  desc 'Rebuild the db with sample data'
  task :rebuild => :environment do
    Rake::Task["db:insert_sample_data"].invoke
  end

  desc 'Insert sample data'
  task :insert_sample_data => :environment do
    Rake::Task["db:roles:create_defaults"].invoke
    Rake::Task["db:countries:create_defaults"].invoke
    Rake::Task["db:gateways:create_defaults"].invoke
    Rake::Task["db:insert_sample_store"].invoke
  end

  desc 'Insert sample(test) store'
  task :insert_sample_store => :environment do
    store = Store.create(:domain => 'ecommerce.dev', :display_name => 'Ecommerce', :email => 'ecommerce@example.com' )
  end 

  desc 'Reset database and reload ALL sample data.'
  task :rebuild_from_scratch => :environment do
    exit unless Rails.env.development?
    Rake::Task["db:reset"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:rebuild"].invoke
  end

  desc 'A task for bootstrapping the db with initial data for development'
  task :build_for_development => :environment do
    exit unless Rails.env.development?
    Rake::Task["db:rebuild_from_scratch"].invoke
  end

  desc 'A task for bootstrapping the db with initial data on first deploy'
  task :build_for_production => :environment do
    exit unless Rails.env.production? && !(ActiveRecord::Base.connection rescue nil)
    Rake::Task["db:rebuild_from_scratch"].invoke
  end
  
end