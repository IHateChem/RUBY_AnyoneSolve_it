class CreateTestms < ActiveRecord::Migration[7.1]
  def change
    create_table :testms do |t|
      t.string :name
      t.json :ids
      t.string :password

      t.timestamps
    end
  end
end
