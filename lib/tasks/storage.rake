namespace :storage do

  desc "Recalculate disk usage"
  task :usage => :environment do
    SharesController.usage_all
  end

end
