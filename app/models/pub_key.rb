class PubKey < ActiveRecord::Base

  belongs_to :user, -> { uniq }

  validates :title, presence: true
  validates :key, presence: true
  validates :fingerprint, presence: true

  #
  # Instance methods
  #

  def append_key
    key_line = "command=#{Rails.root.join('lib', 'sftp-shell', 'sftp_shell.rb')} #{} #{self.key}"
    File.open(PubKey.authorized_keys_path, 'a') { |file| file.write(key_line) }
  end

  #
  # Class methods
  #

  # Returns full authorized_keys path
  def self.authorized_keys_path
    return File.join(Rails.application.config.sftp['home_directory'], '.ssh', 'authorized_keys')
  end
end
