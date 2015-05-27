require 'yaml'

class SFTPConfig

  attr_reader :config

  def initialize
    @config = YAML.load_file(File.join(ROOT_PATH, 'config', 'sftp-shell.yml'))
  end

end
