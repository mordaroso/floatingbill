class TransfersController < ApplicationController
  before_filter :login_required
  before_filter :permission_required, :except => [:index, :new, :create]
  protect_from_forgery :except => [:verify]
  # GET /transfers
  # GET /transfers.xml
  def index
    @open_transfers = Transfer.by_user_id(current_user.id).open
    @closed_transfers = Transfer.by_user_id(current_user.id).closed.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transfers }
    end
  end

  # POST /transfers/1/verify
  def verify
    transfer = Transfer.find(params[:id])
    transfer.verfiy
    flash[:notice] = 'transfer successfully verified.'
    redirect_to(transfer)
  end

  # GET /transfers/1
  # GET /transfers/1.xml
  def show
    @transfer = Transfer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.iphone { render :layout => false }
      format.xml  { render :xml => @transfer }
    end
  end

  # GET /transfers/new
  # GET /transfers/new.xml
  def new
    @transfer = Transfer.new

    respond_to do |format|
      format.html # new.html.erb
      format.iphone { render :layout => false }
      format.xml  { render :xml => @transfer }
    end
  end

  # POST /transfers
  # POST /transfers.xml
  def create
    @transfer = Transfer.new(params[:transfer])
    @transfer.debitor = current_user

    respond_to do |format|
      if @transfer.save
        flash[:notice] = 'Transfer was successfully created.'
        format.html { redirect_to(@transfer) }
        format.iphone { redirect_to(@transfer) }
        format.xml  { render :xml => @transfer, :status => :created, :location => @transfer }
      else
        format.html { render :action => "new" }
        format.iphone { render :action => "new", :layout => false }
        format.xml  { render :xml => @transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.xml
  def destroy
    @transfer = Transfer.find(params[:id])
    @transfer.destroy

    respond_to do |format|
      format.html { redirect_to(transfers_url) }
      format.xml  { head :ok }
    end
  end

  private
  def permission_required
    transfer = Transfer.find(params[:id])
    if transfer.debitor_id != current_user.id && transfer.creditor_id != current_user.id
      redirect_to transfers_path
    end
  end
end
