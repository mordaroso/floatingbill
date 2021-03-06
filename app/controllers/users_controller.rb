class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :activate, :feed]
  before_filter :owner_required, :only => [:edit, :statistics]
  protect_from_forgery :except => [:autocomplete]

  # render new.rhtml
  def new
    @user = User.new
  end

  def dashboard
    @activities = Activities.get_all_by_user(current_user)
    @activities= @activities[-5,5] if @activities.length > 5
    @open_bills = Bill.by_user_id(current_user.id).open.uniq
    respond_to do |format|
      format.html # dashboard.html.haml
      format.iphone{render :layout => false} # dashboard.iphone.haml
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb

    end
  end

  def feed
    @user = User.find(params[:id])
    @activities = Activities.get_all_by_user(@user).reverse if @user.rss_hash == params[:rss_hash]
    respond_to do |format|
      format.rss do # show.rss.builder
        redirect_back_or_default('/') unless @user.rss_hash == params[:rss_hash]
      end
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Settings were successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
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
    login = params[:transfer][:creditor_name] unless params[:transfer].blank?
    login = params[:user][:login] unless params[:user].blank?
    @users = User.find_by_login_like(login)
    render :inline => "<%= auto_complete_result(@users, 'login') %>"
  end

  def statistics
    @user = User.find(params[:id])
    options = Hash.new
    title = String.new
    if params.has_key? 'last_week'
      options[:from] = 1.week.ago
      title = 'Last Week'
    elsif params.has_key? 'last_month'
      options[:from] = 1.month.ago
      title = 'Last Month'
    else
      title = 'Overall'
    end
    respond_to do |format|
      format.html {
        graph = Scruffy::Graph.new(:theme => FloatingBillTheme.new)
        graph.title = "Statistics for " + @user.login + " - " + title
        graph.renderer = Scruffy::Renderers::Pie.new

        graph.add :pie, '', @user.costs_by_category(options)

        send_data  (graph.render :width => 300, :height => 200, :as => 'png')
      }
    end
  end

  private
  def owner_required
    redirect_to user_path(params[:id]) unless current_user.id.to_s == params[:id]
  end
end
