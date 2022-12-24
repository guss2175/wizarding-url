class CreateUrls < ActiveRecord::Migration[6.1]
  UNIQUE_ACTIVE_ALIAS = "index_unique_active_url_alias".freeze

  def up
    create_table :urls do |t|
      t.string :original_url, null: false, limit: Settings.limits.url_length
      t.string :alias, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    execute "CREATE UNIQUE INDEX IF NOT EXISTS #{UNIQUE_ACTIVE_ALIAS} "\
              "ON urls (original_url, alias, COALESCE(deleted_at, timestamp 'infinity'))"
  end

  def down
    remove_index :urls, name: UNIQUE_ACTIVE_ALIAS, if_exists: true

    drop_table :urls
  end
end
