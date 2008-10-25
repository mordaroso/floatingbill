class CategoriesController < ApplicationController
  protect_from_forgery :except => [:autocomplete]

  def autocomplete
    @categories = Category.find_by_name_like(params[:bill][:category_name])
    render :inline => "<%= auto_complete_result(@categories, 'name') %>"
  end
end
