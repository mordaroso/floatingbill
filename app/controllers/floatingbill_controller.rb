class FloatingbillController < ApplicationController
  def index
    if logged_in?
      respond_to do |format|
        format.html {redirect_to(dashboard_user_path(current_user))}
        format.iphone { render :action => :home }
      end
    end
  end

  def terms
  end

  def privacy
  end

  def howto
  end

  def faq
  end

  def contact
  end

end
