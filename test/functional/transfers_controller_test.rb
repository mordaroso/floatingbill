require 'test_helper'

class TransfersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:open_transfers)
    assert_not_nil assigns(:closed_transfers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_transfer
    assert_difference('Transfer.count') do
      post :create, :transfer => {:creditor_name => users(:aaron).login, :amount => 500, :currency => 'chf'}
    end

    assert_redirected_to transfer_path(assigns(:transfer))
  end

  def test_should_verify_transfer_normal
    post :verify, :id => transfers(:one).id

    assert_equal 555.76, users(:aaron).debts.last.amount
    assert_equal 555.76, users(:quentin).credits.last.amount
  end

  def test_should_verify_transfer_edge
    post :verify, :id => transfers(:two).id

    assert_equal 1010.9, users(:aaron).credits.last.amount
    assert_equal 1010.9, users(:quentin).debts.last.amount
  end

  def test_should_show_transfer
    get :show, :id => transfers(:one).id
    assert_response :success
  end

end
