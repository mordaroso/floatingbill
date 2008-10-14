class FloatingbillController < ApplicationController
  def index
    if logged_in?
      redirect_to(dashboard_user_path(current_user))
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
