require 'yaml'
#~ require 'byebug'; byebug
config = YAML.load_file(File.join(__dir__, '..', 'config.yml'))

# Recalculate disk usage periodically
every eval(config['disk_usage_recalc_interval']) do
  rake "storage:usage"
end
