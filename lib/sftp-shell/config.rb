# frozen_string_literal: true

require 'yaml'

class Config
  attr_reader :config

  def initialize
    @config = YAML.load_file(File.join(ROOT_PATH, 'config.yml'))
  end
end
