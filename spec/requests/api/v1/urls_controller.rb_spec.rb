require "rails_helper"

RSpec.describe "Api::V1::UrlsController.rbs", type: :request do
  describe "POST /encode" do
    context "when params is invalid" do
      shared_examples "error on encoding url" do |invalid_url|
        it "should return validation errors when encoding", :aggregate_failures do
          post encode_api_v1_urls_path, params: invalid_url

          expect(response).to have_http_status Settings.http_status_codes.unprocessable_entity
          expect(response_body).to eq error_response
        end
      end

      context "when original_url is not a valid url" do
        include_examples "error on encoding url", {url: "invalid_url"} do
          let(:error_response) do
            {
              success: false,
              errors: [
                {
                  resource: "url",
                  field: "original_url",
                  code: 1009,
                  message: "Original URL is not a valid URL"
                }
              ]
            }
          end
        end
      end

      context "when original_url is too long" do
        VERY_LONG_URL = ("x" * (Settings.limits.url_length + 1)).freeze

        include_examples "error on encoding url", {url: VERY_LONG_URL} do
          let(:error_response) do
            {
              success: false,
              errors: [
                {
                  resource: "url",
                  field: "original_url",
                  code: 1006,
                  message: "Original URL is too long (maximum is 2048 characters)"
                }
              ]
            }
          end
        end
      end
    end

    context "when params is valid" do
      let(:valid_url) {Faker::Internet.url}
      let(:fake_counter) {2000}
      let(:encoded_url) {Converters::Base62.encode(fake_counter)}
      let(:successful_response) do
        {
          success: true,
          data: {
            id: 1,
            original_url: valid_url,
            alias_url: Settings.system.host + encoded_url
          }
        }
      end

      it "should encode long url successfully", :aggregate_failures do
        allow(Url).to receive(:secret_key).and_return fake_counter

        post encode_api_v1_urls_path, params: {url: valid_url}

        expect(response).to have_http_status Settings.http_status_codes.created
        expect(response_body).to eq successful_response
      end
    end
  end

  describe "GET /decode" do
    let_it_be(:encoded_url) {create :url, alias_url: "ABCDEF"}

    context "when params is invalid" do
      let(:invalid_alias) {Settings.system.host + "invalid"}
      let(:not_found_response) do
        {
          success: false,
          errors: [
            {
              resource: "url",
              code: 1100,
              message: "Couldn't find url"
            }
          ]
        }
      end

      it "should return not found when decoding alias", :aggregate_failures do
        get decode_api_v1_urls_path, params: {url: invalid_alias}

        expect(response).to have_http_status Settings.http_status_codes.not_found
        expect(response_body).to eq not_found_response
      end
    end

    context "when params is valid" do
      let(:valid_alias) {encoded_url.full_alias_url}
      let(:successful_response) do
        {
          success: true,
          data: {
            original_url: encoded_url.original_url,
            alias_url: encoded_url.full_alias_url
          }
        }
      end

      it "should return success decoding result" do
        get decode_api_v1_urls_path, params: {url: valid_alias}

        expect(response).to have_http_status Settings.http_status_codes.success
        expect(response_body).to eq successful_response
      end
    end
  end
end
