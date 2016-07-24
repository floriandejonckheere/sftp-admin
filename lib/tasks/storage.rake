namespace :storage do

  desc "Recalculate disk usage"
  task :usage => :environment do
    SharesController.recalculate_usage
  end

end
