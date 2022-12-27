module Helpers
  def response_body
    JSON.parse response.body, symbolize_names: true
  end
end
