module ApiResponse
  def self.to_hash data, success: true
    {success:, data:}
  end
end
