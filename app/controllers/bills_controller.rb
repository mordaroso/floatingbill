class BillsController < ApplicationController
  before_filter :login_required
  before_filter :member_required, :only => [:show, :accept]
  before_filter :creator_required, :only => [:destroy]
  protect_from_forgery :except => [:get_payers]

  # GET /bills
  # GET /bills.xml
  def index
    @open_bills = Bill.by_user_id(current_user.id).open
    @closed_bills = Bill.by_user_id(current_user.id).closed

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.xml
  def show
    @bill = Bill.find(params[:id])
    @news = News.get_all_by_bill(@bill)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/new
  # GET /bills/new.xml
  def new
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # POST /bills/1/accept
  def accept
    bill = Bill.find(params[:id])
    payment = Payment.find_by_user_id_and_bill_id(current_user.id, bill.id)
    payment.accept
    flash[:notice] = 'bill successfully accepted.'
    redirect_to(bill)
  end

  # POST /bills
  # POST /bills.xml
  def create
    @bill = Bill.new(params[:bill])
    @bill.creator = current_user
    respond_to do |format|
      if @bill.save
        flash[:notice] = 'bill was successfully created.'
        format.html { redirect_to(@bill) }
        format.xml  { render :xml => @bill, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(bills_url) }
      format.xml  { head :ok }
    end
  end

  def get_payers
    unless params[:payer].blank?
      @users = User.find_by_login_like(params[:payer])
      @groups = Group.find_by_name_like(params[:payer])
    end
  end

  private
  def member_required
    bill = Bill.find(params[:id])
    if !(bill.payers.include? current_user) && bill.creator != current_user
      redirect_to bills_path
    end
  end

  def creator_required
    bill = Bill.find(params[:id])
    redirect_to bills_path if bill.creator != current_user
  end
end
