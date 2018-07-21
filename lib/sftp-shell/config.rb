# frozen_string_literal: true

require 'yaml'

module SFTPShell
  class Config
    def self.read
      YAML.load_file File.join ROOT_PATH, 'config', 'sftp.yml'
    end
  end
end
