# frozen_string_literal: true

require 'logger'

require_relative 'config'

config = Config.new.config

$logger = Logger.new(config['sftp_log'])
