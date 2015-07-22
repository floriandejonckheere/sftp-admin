namespace :keys do

  desc "Regenerate the authorized_keys file"
  task :regen => :environment do
    PubKeysController.write_keys
  end

end
