module Api::V1
  class UrlsController < ApiController
    # POST api/v1/urls/encode
    def encode
      url = Url.create!(
        original_url: params[:url],
        alias_url: Converters::Base62.encode(Url.secret_key)
      )

      render_created ApiResponse.to_hash UrlSerializer.new(url)
    end

    # GET api/v1/urls/decode
    def decode
      url = Url.find_by! alias_url: extract_alias_url

      render_success ApiResponse.to_hash UrlSerializer.new(url, type: :basic_info)
    end

    private

    def extract_alias_url
      params[:url]&.gsub Settings.system.host, ""
    end
  end
end
