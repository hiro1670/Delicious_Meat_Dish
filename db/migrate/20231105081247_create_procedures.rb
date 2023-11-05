class CreateProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.integer :recipe_id, null: false#レシピID
      t.text :body, null: false#作り方
      t.timestamps
    end
  end
end
