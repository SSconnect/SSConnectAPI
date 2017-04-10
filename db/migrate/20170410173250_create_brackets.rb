class CreateBrackets < ActiveRecord::Migration[5.0]
  def change
    create_table :brackets do |t|
      t.string :title
      t.timestamps
    end
  end
end
