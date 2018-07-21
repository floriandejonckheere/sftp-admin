# frozen_string_literal: true

namespace :storage do
  desc 'Recalculate disk usage'
  task :usage => :environment do
    Share.recalculate_all_usage!
  end
end
