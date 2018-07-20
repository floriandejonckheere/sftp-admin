# frozen_string_literal: true

require 'net/http'
require 'yaml'
require 'json'

require_relative 'config'

class SFTPAPI
  attr_accessor :config

  def initialize
    @config = Config.new.config
  end

  def get_user(user_id)
    request "/users/#{user_id}"
  end

  def get_share(share_path); end

  def check_assess(share, user); end

  def request(request_uri)
    uri = URI.join @config['api_endpoint'], request_uri
    @http ||= Net::HTTP.new uri.hostname, uri.port

    res = @http.get uri.request_uri, 'Accept' => 'application/json'

    JSON.parse res.body
  end
end
