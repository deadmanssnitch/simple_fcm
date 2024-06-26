# frozen_string_literal: true

require "faraday"

module SimpleFCM
  class AuthorizationMiddleware < Faraday::Middleware
    # Automatically refresh the access token when it is due to expire within
    # the next 3 minutes.
    DEFAULT_EXPIRY_THRESHOLD = 180

    def initialize(app, credentials, expiry_threshold: DEFAULT_EXPIRY_THRESHOLD)
      @credentials = credentials
      @expiry_threshold = expiry_threshold

      if @expiry_threshold < 0
        raise ArugmentError, "expiry_threshold must be greater than or equal to 0"
      end

      super(app)
    end

    # Force a refresh of the access token
    def refresh!
      fetched = @credentials.fetch_access_token!

      @token = fetched["access_token"]
      @type = fetched["token_type"]
      @expires_at = Time.now.utc + fetched["expires_in"]
    end

    # Returns true when the access token should be fetched or refreshed.
    def refresh?
      @expires_at.nil? || @expires_at <= (Time.now.utc - @expiry_threshold)
    end

    def on_request(env)
      if refresh?
        refresh!
      end

      env.request_headers["Authorization"] = "#{@type} #{@token}"
    end
  end
end

Faraday::Request.register_middleware(simple_fcm_auth: SimpleFCM::AuthorizationMiddleware)
