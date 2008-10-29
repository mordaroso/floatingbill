class CategoriesController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => [:autocomplete]

  def autocomplete
    @categories = Category.find_by_name_like(params[:bill][:category_name])
    render :inline => "<%= auto_complete_result(@categories, 'name') %>"
  end

  def show
    @category = Category.find(params[:id])
    @bills = Bill.by_user_id(current_user.id).by_category_id(@category.id)
  end
end
