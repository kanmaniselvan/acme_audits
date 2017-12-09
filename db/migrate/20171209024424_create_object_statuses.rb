class CreateObjectStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :object_statuses do |t|
      t.integer :object_id, null: false
      t.string :object_type, null: false
      t.string :timestamp, null: false
      t.jsonb :object_changes, null: false

      t.timestamps null: false
    end

    # Indexed in the order of Querying.
    add_index :object_statuses, [:object_type, :object_id, :timestamp, :object_changes], unique: true, name: 'uniq_object_statuses_record_index'
  end
end
