class CreateRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name#材料名
      t.string :quantity#分量

      t.timestamps
    end
  end
end
