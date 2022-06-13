class CreateActiveStorageTables < ActiveRecord::Migration[5.2]
  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def change
    create_table :active_storage_blobs do |t|
      t.string   :key,          null: false
      t.string   :filename,     null: false
      t.string   :service_name, null: false
      t.string   :content_type
      t.text     :metadata
      t.bigint   :byte_size,    null: false
      t.string   :checksum,     null: false
      t.datetime :created_at,   null: false

      t.index [:key], unique: true
    end

    create_table :active_storage_attachments do |t|
      t.string     :name,     null: false
      t.references :record,   null: false, polymorphic: true, index: false
      t.references :blob,     null: false

      t.datetime :created_at, null: false

      t.index %i[record_type record_id name blob_id],
              name: "index_active_storage_attachments_uniqueness", unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize
end

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users
  end
end

class User < ActiveRecord::Base
  has_one_attached :avatar
end

def setup_database
  ActiveRecord::Migration.suppress_messages do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Base.connection.migration_context.migrate
    CreateActiveStorageTables.migrate(:up)
    CreateUsers.migrate(:up)
  end
end
