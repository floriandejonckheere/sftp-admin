require 'rest-client'
require_relative 'sftp_config'

class SFTPShell

  class AccessDeniedError < StandardError; end
  class DisallowedCommandError < StandardError; end
  class InvalidSharePathError < StandardError; end

  attr_accessor :config, :user_id, :original_cmd

  def initialize(user_id, original_cmd)
    @config = SFTPConfig.new.config
    @user_id = user_id
    @original_cmd = original_cmd
  end

  def exec
    return false unless @original_cmd

    user = JSON.parse!(RestClient.get URI.join(@config['api_endpoint'], '/users/', user_id).to_s, {:accept => :json})
    p user
    puts "Welcome, #{user['name']}!"
    return true
  end

  def exec_cmd(*args)
    Kernel::exec({ 'PATH' => ENV['PATH'], 'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'] }, *args, unsetenv_others: true)
  end

end
