class CreateSwings < ActiveRecord::Migration[5.0]
  def change
    create_table :swings do |t|
      t.string :wrong
      t.string :correct
      t.timestamps
    end
  end
end
