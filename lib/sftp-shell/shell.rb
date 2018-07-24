# frozen_string_literal: true

require 'shellwords'
require 'logger'

require_relative 'config'
require_relative 'errors'
require_relative 'api'

# Commands allowed in shell
ALLOWED_COMMANDS = %w[sftp scp rsync].freeze

module SFTPShell
  class Shell
    attr_accessor :config,
                  :logger,
                  :user,
                  :share

    def initialize(user_id, original_command)
      @user_id = user_id
      @original_command = original_command

      @config = Config.read
      @logger = Logger.new @config['shell']['log']
    end

    def exec
      @user = API::User.new @user_id
      @logger.info "Authenticated user #{@user_id} with command #{@original_command}"
      puts "sftp-shell: Welcome, #{@user.name}!"

      return false unless @original_command

      parse_cmd
      verify_access
      execute_cmd @original_command
      true
    rescue AccessDeniedError => _
      @logger.warn "Access denied for user #{@user_id}: #{@original_command}"
      puts "sftp-shell: #{@original_command}: Access denied."
      false
    rescue DisallowedCommandError => _
      @logger.warn "Command not allowed for user #{@user_id}: #{@original_command}"
      puts "sftp-shell: #{@cmd.first}: Command not allowed."
      false
    rescue InvalidSharePathError => _
      @logger.warn "Invalid share path for user #{@user_id}: #{@original_command}"
      puts "sftp-shell: #{@original_command}: Invalid share path"
      false
    rescue ServerError => ex
      @logger.error "Server error for user #{@user_id}: #{@original_command}"
      @logger.error ex
      puts 'sftp-shell: Server error'
      false
    end

    private

    def parse_cmd
      @cmd = Shellwords.shellwords @original_command

      raise DisallowedCommandError unless ALLOWED_COMMANDS.include? @cmd.first

      @share_path = @cmd.last
      @logger.info "Accessing share path #{@share_path}"
    end

    def verify_access
      # TODO: prevent spoofing share path
      full_path = File.expand_path File.join @config['storage_path'], @share_path
      raise InvalidSharePathError unless full_path.start_with? @config['storage_path']

      # TODO: support subdirectory shares
      @share = API::Share.new @share_path.split(File::SEPARATOR).first
      raise InvalidSharePathError unless @share

      access = API::Authorization.new @share.id, @user.id
      raise AccessDeniedError unless access.authorized
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
