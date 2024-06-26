# frozen_string_literal: true

require "spec_helper"

require "securerandom"
require "googleauth/credentials"

RSpec.describe SimpleFCM::Client do
  let(:token) do
    {
      "access_token" => SecureRandom.uuid,
      "token_type" => "Bearer",
      "expires_in" => 3600
    }
  end

  subject(:client) do
    allow(Google::Auth::ServiceAccountCredentials)
      .to receive(:make_creds)
      .and_return(
        double(Google::Auth::Credentials, project_id: "widgets", fetch_access_token!: token)
      )

    SimpleFCM::Client.new("MOCK")
  end

  let(:url) { "#{SimpleFCM::Client.const_get(:ENDPOINT)}/v1/projects/widgets/messages:send" }
  let(:headers) { {authorization: "Bearer #{token["access_token"]}"} }

  it "can send a push notification" do
    stub = stub_request(:post, url)
      .with(headers: headers)
      .to_return(
        headers: {content_type: "application/json"},
        body: '{"name": "projects/widgets/messages/0:1"}'
      )

    id = client.push({
      message: {
        token: "1234"
      }
    })

    expect(stub).to have_been_made
    expect(id).to eq("projects/widgets/messages/0:1")
  end
end
