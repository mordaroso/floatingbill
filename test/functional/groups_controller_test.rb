require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_group
    assert_difference('Group.count') do
      post :create, :group => {:name => 'test'}
    end

    assert_redirected_to group_path(assigns(:group))
  end

  def test_should_show_group
    get :show, :id => groups(:wg).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => groups(:wg).id
    assert_response :success
  end

  def test_should_update_group
    put :update, :id => groups(:wg).id, :group => { }
    assert_redirected_to group_path(assigns(:group))
  end

  def test_should_destroy_group
    delete :destroy, :id => groups(:wg).id
    assert_redirected_to groups_path
  end
end
