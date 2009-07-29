namespace :db do
  namespace :gateways do
    desc 'Create default gateways'
    task :create_defaults => :environment do
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Creating default gateways..."
      gateways = Gateway.create(GATEWAYS)
      Store.all.each{ |store| store.gateways << gateways }
      puts "Default gateways created successfully"
    end
  end
end