class KeyManager

  @@authorized_keys_path = File.join(Rails.application.config.sftp['home_directory'], '.ssh', 'authorized_keys')

  def self.update_keys
    File.open @@authorized_keys_path, 'w' do |file|
      PubKey.all.each do |key|
        Rails.logger.info "Writing key #{key.id} for user #{key.user.id} to #{@@authorized_keys_path}"
        file.puts "command=\"#{Rails.root.join('bin', 'sftp-shell')} #{key.user.id}\" #{key.key}"
      end
    end
  end

end
