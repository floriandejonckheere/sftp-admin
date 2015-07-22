class KeyManager

  @@authorized_keys_path = File.join(Rails.application.config.sftp['home_directory'], '.ssh', 'authorized_keys')
  def self.authorized_keys_path
    @@authorized_keys_path
  end

  def self.key_command(key_id)
    "#{Rails.root.join('lib', 'sftp-shell', 'sftp_shell.rb')} #{key_id}"
  end

  def self.add_key(key_id)
    Rails.logger.info "Writing key #{key_id} to #{KeyManager.authorized_keys_path}"
    key = PubKey.find(key_id)
    raise "Key #{key_id} not found" if key.nil?
    key_line = "command=\"#{KeyManager.key_command(key_id)}\" #{key.key}\n"
    File.open(KeyManager.authorized_keys_path, 'a') { |file| file.write(key_line) }
  end

  def self.add_all_keys
    KeyManager.clear
    PubKey.all.each do |pub_key|
      KeyManager.add_key(pub_key.id)
    end
  end

  def self.rm_key(key_id)
    Rails.logger.info "Removing key #{key_id} from #{KeyManager.authorized_keys_path}"
      Tempfile.open('authorized_keys') do |temp|
        open(KeyManager.authorized_keys_path, 'r+') do |current|
          current.each do |line|
            temp.puts(line) unless line.start_with?("command=\"#{KeyManager.key_command(key_id)}\"")
          end
        end
        temp.close
        FileUtils.cp(temp.path, KeyManager.authorized_keys_path)
      end
  end

  def self.clear
    Rails.logger.info "Clearing all keys from #{KeyManager.authorized_keys_path}"
    File.open(KeyManager.authorized_keys_path, 'w') {}
  end

end
