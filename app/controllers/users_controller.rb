class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :activate]
  before_filter :owner_required, :only => [:edit]
  protect_from_forgery :except => [:autocomplete]

  # render new.rhtml
  def new
    @user = User.new
  end

  def dashboard
    
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def autocomplete
    @users = User.find_by_login_like(params[:transfer][:creditor_name])
    render :inline => "<%= auto_complete_result(@users, 'login') %>"
  end

  private
  def owner_required
    redirect_to user_path(params[:id]) unless current_user.id.to_s == params[:id]
  end
end

