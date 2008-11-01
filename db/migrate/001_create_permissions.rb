class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :controllable_id
      t.string  :controllable_type

      t.string  :action
      t.string  :rule

      t.timestamps
    end

    add_index :permissions, [:controllable_id, :controllable_type]
  end

  def self.down
    drop_table :permissions
  end
end
