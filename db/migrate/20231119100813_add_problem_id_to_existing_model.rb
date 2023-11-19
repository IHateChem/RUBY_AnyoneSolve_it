class AddProblemIdToExistingModel < ActiveRecord::Migration[7.1]
  def change
    add_column :New_models, :problemId, :integer
  end
end
