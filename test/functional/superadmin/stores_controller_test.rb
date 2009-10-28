require 'test_helper'

class Superadmin::StoresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:superadmin_stores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store" do
    assert_difference('Superadmin::Store.count') do
      post :create, :store => { }
    end

    assert_redirected_to store_path(assigns(:store))
  end

  test "should show store" do
    get :show, :id => superadmin_stores(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => superadmin_stores(:one).to_param
    assert_response :success
  end

  test "should update store" do
    put :update, :id => superadmin_stores(:one).to_param, :store => { }
    assert_redirected_to store_path(assigns(:store))
  end

  test "should destroy store" do
    assert_difference('Superadmin::Store.count', -1) do
      delete :destroy, :id => superadmin_stores(:one).to_param
    end

    assert_redirected_to superadmin_stores_path
  end
end
