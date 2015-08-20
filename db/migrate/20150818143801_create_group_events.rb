class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string     :name
      t.string     :description
      t.string     :location

      t.integer    :flags, null: false, default: 0

      t.datetime   :start_at
      t.datetime   :end_at

      t.timestamps
    end
  end
end
