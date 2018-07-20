# frozen_string_literal: true

require 'logger'

require_relative 'sftp_config'

config = SFTPConfig.new.config

$logger = Logger.new(config['sftp_log'])
