class EditPolls < ActiveRecord::Migration
  def change
    rename_column :polls, :author, :author_id
    change_column :polls, :author_id, :integer 
  end
end