class Url < ApplicationRecord
  acts_as_paranoid

  validates :alias_url, presence: true,
                        uniqueness: {scope: %i(original_url deleted_at)},
                        length: {maximum: Settings.limits.alias_url_length}
  validates :original_url, presence: true,
                           length: {maximum: Settings.limits.url_length},
                           format: {with: Settings.regex.valid_url, message: :invalid}

  class << self
    # fake zookeeper counter
    def secret_key
      Settings.system.counter.starting_point + maximum(:id).to_i + 1
    end
  end

  def full_alias_url
    Settings.system.host + alias_url
  end
end
