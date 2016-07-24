require 'net/http'
require 'yaml'
require 'json'

require_relative 'sftp_config'

class SFTPAPI

  attr_accessor :config

  def initialize
    @config = SFTPConfig.new.config
  end

  def get_user(user_id)
    uri = URI.join @config['api_endpoint'], '/users/', user_id
    http = Net::HTTP.new uri.hostname, uri.port
    res = http.get uri.request_uri, { 'Accept' => 'application/json' }

    json = JSON.parse res.body
  end

  def check_share_path(share_path)
  end

end
