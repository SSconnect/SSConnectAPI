class RenameLastPostedAtToFirst < ActiveRecord::Migration[5.0]
  def change
    rename_column :stories, :last_posted_at, :first_posted_at
  end
end
