# frozen_string_literal: true

require 'yaml'

config = YAML.load_file File.join __dir__, '..', 'config', 'sftp.yml'

every config['disk_usage_recalc_interval'].hours do
  rake 'storage:usage'
end
