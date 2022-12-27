class UrlSerializer < ApplicationSerializer
  DEFAULT = %i(id original_url alias_url).freeze
  BASIC_INFO = %i(original_url alias_url).freeze

  attributes(*DEFAULT)

  def alias_url
    object.full_alias_url
  end
end
