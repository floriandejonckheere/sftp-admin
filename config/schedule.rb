# frozen_string_literal: true

require 'yaml'

config = YAML.load_file File.join __dir__, '..', 'config', 'sftp.yml'

every eval(config['disk_usage_recalc_interval']) do
  rake 'storage:usage'
end
