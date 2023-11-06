class CreateProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :body, null: false#作り方
      t.timestamps
    end
  end
end
