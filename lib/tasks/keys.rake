# frozen_string_literal: true

require 'key_manager'

namespace :keys do
  desc 'Update the authorized_keys file'
  task :update => :environment do
    KeyManager.update_keys
  end
end
