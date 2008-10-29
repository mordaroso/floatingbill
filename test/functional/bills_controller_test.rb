require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:open_bills)
    assert_not_nil assigns(:closed_bills)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user_bill
    assert_difference('Bill.count') do
      post :create, :bill => valid_user_bill_attributes
    end

    assert_equal 3, assigns(:bill).payments.length
    for payment in assigns(:bill).payments
      assert_equal 4.03, payment.amount
    end

    assert_equal categories(:food), assigns(:bill).category

    assert_redirected_to bill_path(assigns(:bill))
  end

  def test_should_create_group_bill
    assert_difference('Bill.count') do
      post :create, :bill => valid_group_bill_attributes
    end

    assert_equal(2, assigns(:bill).payments.length)
    for payment in assigns(:bill).payments
      assert_equal 6.05, payment.amount
    end

    assert_redirected_to bill_path(assigns(:bill))
  end

  def test_should_create_user_group_bill
    assert_difference('Bill.count') do
      post :create, :bill => valid_user_group_bill_attributes
    end

    assert_equal(3, assigns(:bill).payments.length)
    for payment in assigns(:bill).payments
      assert_equal 4.03, payment.amount
    end

    assert_redirected_to bill_path(assigns(:bill))
  end

  def test_should_accept_bill_normal
    login_as :aaron

    post :accept, :id => bills(:food).id

    assert_equal(45.55, users(:aaron).debts.first.amount)
    assert_equal(45.55, users(:quentin).credits.first.amount)
  end

  def test_should_accept_bill_edge
    login_as :sam

    post :accept, :id => bills(:food).id

    assert_equal(19.05, users(:sam).debts.last.amount)
    assert_equal(19.05, users(:quentin).credits.last.amount)
  end

  def test_should_show_bill
    get :show, :id => bills(:food).id
    assert_response :success
  end

  private
  def valid_user_bill_attributes
    {
      :user_ids => [1,2,3]
    }.merge no_payer_bill_attributes
  end

  def valid_group_bill_attributes
    {
      :group_ids => [1]
    }.merge no_payer_bill_attributes
  end

  def valid_user_group_bill_attributes
    {
      :group_ids => [1],
      :user_ids => [2]
    }.merge no_payer_bill_attributes
  end

  def no_payer_bill_attributes
    {
      :category_name => "food",
      :amount => 12.10,
      :name => "valid bill",
      :description => "this is a valid bill",
      :currency => "chf",
    }
  end
end
