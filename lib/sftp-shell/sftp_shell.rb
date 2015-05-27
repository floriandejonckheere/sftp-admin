ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

require_relative 'sftp_config'

class SFTPShell

  class AccessDeniedError < StandardError; end
  class DisallowedCommandError < StandardError; end

  attr_accessor :config, :user_id, :original_cmd

  def initialize(user_id, original_cmd)
    @config = SFTPConfig.new.config
    @user_id = user_id
    @original_cmd = original_cmd
  end

  def exec
    # Authentication
  end

  def exec_cmd(*args)
    Kernel::exec({ 'PATH' => ENV['PATH'], 'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'] }, *args, unsetenv_others: true)
  end

end
