class Public::SearchesController < ApplicationController
  def search
    @word = params[:word]
    @recipes = Recipe.search(params[:word])
  end
end
