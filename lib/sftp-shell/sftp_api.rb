require 'rest-client'
require 'yaml'

require_relative 'sftp_config'

class SFTPAPI

  attr_accessor :config

  def initialize
    @config = SFTPConfig.new.config
  end

  def get_user(user_id)
    JSON.parse!(RestClient.get URI.join(@config['api_endpoint'], '/users/', user_id).to_s, {:accept => :json})
  end

  def check_share_path(share_path)
  end

end
