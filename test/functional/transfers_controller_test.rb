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
      post :create, :transfer => {:creditor_name => users(:quentin).login, :amount => 500, :currency => 'chf'}
    end

    assert_redirected_to transfer_path(assigns(:transfer))
  end

  def test_should_show_transfer
    get :show, :id => transfers(:one).id
    assert_response :success
  end

  def test_should_destroy_transfer
    assert_difference('Transfer.count', -1) do
      delete :destroy, :id => transfers(:one).id
    end

    assert_redirected_to transfers_path
  end
end
