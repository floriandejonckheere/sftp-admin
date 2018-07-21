# frozen_string_literal: true

class KeyManager
  @authorized_keys_path = File.join Rails.application.config.sftp['home_directory'], '.ssh'
  @authorized_keys_file = File.join @authorized_keys_path, 'authorized_keys'

  def self.update_keys
    FileUtils.mkdir_p @authorized_keys_path unless File.directory? @authorized_keys_path

    File.open @authorized_keys_file, 'w' do |file|
      Key.all.each do |key|
        Rails.logger.info "Writing key #{key.id} for user #{key.user.id} to #{@authorized_keys_file}"
        file.puts "command=\"#{Rails.root.join('bin', 'sftp-shell')} #{key.user.id}\" #{key.key}"
      end
    end

    FileUtils.chmod 0o700, @authorized_keys_path
    FileUtils.chmod 0o600, @authorized_keys_file
  end
end
