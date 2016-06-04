class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :moderator_id, null:false
      t.index :moderator_id, unique: true

      t.timestamps null: false
    end
  end
end
