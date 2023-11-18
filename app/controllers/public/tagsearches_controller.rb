class Public::TagsearchesController < ApplicationController
  def search
    @word = params[:tag]
    @recipes = Recipe.where("tag LIKE?", "%#{@word}%").page(params[:page])
  end
end
