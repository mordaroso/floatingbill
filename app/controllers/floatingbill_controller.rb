class FloatingbillController < ApplicationController
  def index
    if logged_in?
      redirect_to(dashboard_user_path(current_user))
    end
  end
end
