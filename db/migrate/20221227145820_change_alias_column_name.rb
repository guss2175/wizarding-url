class ChangeAliasColumnName < ActiveRecord::Migration[6.1]
  UNIQUE_ACTIVE_ALIAS = "index_unique_active_url_alias".freeze

  def up
    rename_column :urls, :alias, :alias_url

    remove_index :urls, name: UNIQUE_ACTIVE_ALIAS, if_exists: true
    execute "CREATE UNIQUE INDEX IF NOT EXISTS #{UNIQUE_ACTIVE_ALIAS} "\
              "ON urls (original_url, alias_url, COALESCE(deleted_at, timestamp 'infinity'))"
  end

  def down
    remove_index :urls, name: UNIQUE_ACTIVE_ALIAS, if_exists: true
    execute "CREATE UNIQUE INDEX IF NOT EXISTS #{UNIQUE_ACTIVE_ALIAS} "\
              "ON urls (original_url, alias, COALESCE(deleted_at, timestamp 'infinity'))"

    rename_column :urls, :alias_url, :alias
  end
end
