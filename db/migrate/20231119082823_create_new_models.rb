class CreateNewModels < ActiveRecord::Migration[7.1]
  def change
    create_table :new_models do |t|
      t.references :room, null: false, foreign_key: true
      t.string :title
      t.string :level
      t.json :tags
      t.datetime :expired

      t.timestamps
    end
  end
end
