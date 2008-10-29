class GroupsController < ApplicationController
  #TODO remove users from group
  #TODO set users as admin
  before_filter :login_required
  before_filter :member_required, :except => [:show, :index, :new, :create]
  before_filter :admin_required, :only => [:edit, :update, :add]

  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.find_all_with_filter(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.add_admin current_user
    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /groups/1/leave
  def leave
    @group = Group.find(params[:id])
    if @group.remove_member(current_user)
      flash[:notice] = 'You left the group.'
      @group.save
    else
      flash[:error] = 'You are the last admin and can not leave!'
    end
    redirect_to(@group)
  end

  # POST /groups/1/add
  def add
    @group = Group.find(params[:id])
    @user = User.find_by_login(params[:user][:login])
    unless @user.blank? or @group.members.include? @user
      @group.members << @user
      @group.save!
      flash[:notice] = @user.login + ' joined the group.'
    else
      flash[:error] = "User '#{params[:user][:login]}' not found or is already in group!"
    end
    redirect_to(@group)
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.delete_group
    flash[:notice] = 'Group was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  def statistics
    @group = Group.find(params[:id])
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
        graph.title = "Statistics for " + @group.name + " - " + title
        graph.renderer = Scruffy::Renderers::Pie.new

        graph.add :pie, '', @group.costs_by_category(options)

        send_data  (graph.render :width => 300, :height => 200, :as => 'png')
      }
    end
  end

  private
  def admin_required
    redirect_to group_path(params[:id]) unless Group.find(params[:id]).admins.include? current_user
  end

  def member_required
    redirect_to group_path(params[:id]) unless Group.find(params[:id]).members.include? current_user
  end
end
