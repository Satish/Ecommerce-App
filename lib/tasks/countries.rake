namespace :db do
  namespace :countries do
    desc 'Create default countries'
   
    task :create_defaults => :environment do
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Creating default countries..."
      countries = Country.create(ISO_COUNTRIES)
      Store.all.each{ |store| store.countries << countries }
      puts "Default countries created successfully"
    end
  end
end