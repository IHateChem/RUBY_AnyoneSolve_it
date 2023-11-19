class NewModel < ActiveRecord::Migration[7.1]
  def change
    add_column :NewModels, :problemId, :integer
  end
end
