# frozen_string_literal: true

require 'net/http'
require 'json'

require_relative 'config'
require_relative 'errors'

module SFTPShell
  module API
    class User
      attr_accessor :id,
                    :name

      def initialize(user_id)
        response = API.request "/users/#{user_id}.json"

        @id = response['id']
        @name = response['name']
      end
    end

    def self.request(request_uri)
      config = Config.read

      uri = URI.join config['shell']['api'], request_uri
      http ||= Net::HTTP.new uri.hostname, uri.port

      res = http.get uri.request_uri, 'Accept' => 'application/json'

      JSON.parse res.body
    rescue StandardError => ex
      # TODO: error handling
      raise SFTPShell::ServerError, ex
    end
  end
end
