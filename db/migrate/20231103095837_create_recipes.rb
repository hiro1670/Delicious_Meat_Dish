class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.integer :user_id, null: false#ユーザーID
      t.string :name, null: false#レシピ名
      t.string :explanation, null: false#説明
      t.string :tag, null: false#タグ
      t.timestamps
    end
  end
end
