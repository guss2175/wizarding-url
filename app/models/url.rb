class Url < ApplicationRecord
  acts_as_paranoid

  validates :original_url, presence: true, length: {maximum: Settings.limits.url_length}
  validates :alias, presence: true, uniqueness: {scope: %i(original_url deleted_at)}
end
