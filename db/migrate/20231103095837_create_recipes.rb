class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.integer :customer_id, null: false#顧客ID
      t.string :name, null: false#レシピ名
      t.string :explanation, null: false#説明
      t.text :process, null: false#手順
      t.string :tag, null: false#タグ
      t.timestamps
    end
  end
end
