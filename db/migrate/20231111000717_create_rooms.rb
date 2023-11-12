class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.json :ids
      t.string :password

      t.timestamps
    end
  end
end
