module Api::V1
  class UrlsController < ApiController
    # POST api/v1/urls/encode
    def encode
      url = Url.create!(
        original_url: encode_params[:original_url],
        alias: encode_params[:alias] || Converters::Base62.encode(Url.secret_key)
      )

      render_created ApiResponse.to_hash UrlSerializer.new(url)
    end

    # GET api/v1/urls/decode
    def decode
      url = Url.find_by! alias: params[:alias]

      render_success ApiResponse.to_hash UrlSerializer.new(url, type: :basic_info)
    end

    private

    def encode_params
      params.require(:url).permit :original_url, :alias
    end
  end
end
