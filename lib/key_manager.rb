class KeyManager

  @@authorized_keys_path = File.join(Rails.application.config.sftp['home_directory'], '.ssh', 'authorized_keys')
  def self.authorized_keys_path
    @@authorized_keys_path
  end

  def self.key_command(user_id)
    "#{Rails.root.join('bin', 'sftp-shell')} #{user_id}"
  end

  def self.add_key(key_id)
    key = PubKey.find(key_id)
    raise "Key #{key_id} not found" if key.nil?
    Rails.logger.info "Writing key #{key.user.id} to #{KeyManager.authorized_keys_path}"
    key_line = "command=\"#{KeyManager.key_command(key.user.id)}\" #{key.key}"
    File.open(KeyManager.authorized_keys_path, 'a') { |file| file.write(key_line) }
  end

  def self.add_all_keys
    KeyManager.clear
    PubKey.all.each do |pub_key|
      KeyManager.add_key(pub_key.id)
    end
  end

  def self.rm_key(key_id)
    key = PubKey.find(key_id)
    raise "Key #{key_id} not found" if key.nil?
    Rails.logger.info "Removing key #{key_id} from #{KeyManager.authorized_keys_path}"
      Tempfile.open('authorized_keys') do |temp|
        open(KeyManager.authorized_keys_path, 'r+') do |current|
          current.each do |line|
            temp.puts(line) unless line.start_with?("command=\"#{KeyManager.key_command(key.user.id)}\"")
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

  def self.regenerate_all
    Rails.logger.info "Regenerating authorized_keys file for #{PubKey.count} keys"
    self.clear
    self.add_all_keys
  end

end
