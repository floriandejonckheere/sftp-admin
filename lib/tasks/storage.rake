namespace :storage do

  desc "Recalculate storage usage"
  task :usage => :environment do
    Share.all.each do |share|
      share.usage
    end
  end

end
