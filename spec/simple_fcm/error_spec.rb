# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleFCM::Error do
  describe SimpleFCM::APIError do
    {
      400 => SimpleFCM::InvalidArgumentError,
      401 => SimpleFCM::ThirdPartyAuthenticationError,
      403 => SimpleFCM::SenderMismatchError,
      404 => SimpleFCM::UnregisteredError,
      429 => SimpleFCM::QuotaExceededError,
      500 => SimpleFCM::InternalServerError,
      503 => SimpleFCM::ServiceUnavailableError
    }.each do |status, error|
      it "returns #{status} returns a #{error}" do
        resp = double(Faraday::Response, status: status, body: {
          error: {
            code: status,
            status: "ERROR",
            message: error.to_s,
            details: {}
          }
        })
        expect(SimpleFCM::APIError.exception(resp)).to be_a(error)
      end
    end
  end
end
