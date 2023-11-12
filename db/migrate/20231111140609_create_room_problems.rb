class CreateRoomProblems < ActiveRecord::Migration[7.1]
  def change
    create_table :room_problems do |t|
      t.integer :room_id
      t.json :ids
      t.datetime :timeExpired

      t.timestamps
    end
  end
end
