# frozen_string_literal: true

require "googleauth/service_account"

require "simple_fcm/error"
require "simple_fcm/authorization_middleware"

module SimpleFCM
  class Client
    ENDPOINT = "https://fcm.googleapis.com"
    private_constant :ENDPOINT

    SCOPE = "https://www.googleapis.com/auth/firebase.messaging"
    private_constant :SCOPE

    # @param config [string, nil] Either the path to a service account json
    #   config file, the contents of that file as a string, or nil to load
    #   config options from environment configs.
    #
    # @yield [conn] Yields into the connection building process
    # @yieldparam [Faraday::Connection] The backend connection used for requests
    def initialize(config = nil)
      @credentials = build_credentials(config)

      @client = Faraday::Connection.new(ENDPOINT) do |conn|
        conn.request :simple_fcm_auth, @credentials
        conn.request :json
        conn.response :json, parser_options: {symbolize_names: true}

        if block_given?
          yield conn
        end
      end
    end

    # Send a push notification to a device or topic through Firebase Cloud
    # Messaging.
    #
    # @see https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send
    #
    # @param message [Hash] Message payload
    #
    # @raise [APIError]
    # @return [string] Message ID returned by the API
    def push(message)
      resp = @client.post("/v1/projects/#{project_id}/messages:send", message)

      if !resp.success?
        raise ::SimpleFCM::APIError, resp
      end

      resp.body[:name]
    end

    private

    def build_credentials(config = nil)
      # Config options are pulled from environment variables.
      if config.nil?
        return Google::Auth::ServiceAccountCredentials.make_creds(scope: SCOPE)
      end

      if !config.is_a?(String)
        raise ArgumentError, "config must be a string"
      end

      if File.exist?(config)
        config = File.read(config)
      end

      ::Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(config),
        scope: SCOPE
      )
    end

    def project_id
      @credentials.project_id
    end
  end
end
