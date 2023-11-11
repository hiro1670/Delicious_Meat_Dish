class Public::HomesController < ApplicationController
  def top
    # ASCだと古い順でDESCで新着順です。
    @recipes = Recipe.order('id DESC').limit(3)
  end
  
  def about
    
  end
end
