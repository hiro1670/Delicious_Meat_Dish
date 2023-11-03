class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :comment, null: false#コメント
      t.integer :customer_id, null: false#顧客ID
      t.integer :recipe_id, null: false#レシピID
      t.string :star#評価の星
      t.timestamps
    end
  end
end
