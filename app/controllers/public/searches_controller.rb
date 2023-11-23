class Public::SearchesController < ApplicationController
  def search
    @word = params[:word]
    @recipes = Recipe.joins(:recipe_ingredients).search(params[:word])
    @recipes = Kaminari.paginate_array(@recipes).page(params[:page])
  end
end