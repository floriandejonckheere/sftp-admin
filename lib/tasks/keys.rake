namespace :keys do

  desc "Regenerate the authorized_keys file"
  task :regenerate => :environment do
    KeyManager.regenerate_all
  end

end
