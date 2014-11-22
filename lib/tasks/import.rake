namespace :import do

  desc "Import Restaurant info from OpenTable"
  task :restaurants => :environment do
    Restaurant.dump_and_refresh_all
  end
end
