class UrlSerializer < ApplicationSerializer
  DEFAULT = %i(id original_url alias).freeze
  BASIC_INFO = %i(original_url alias).freeze

  attributes(*DEFAULT)

  def alias
    object.full_alias
  end
end
