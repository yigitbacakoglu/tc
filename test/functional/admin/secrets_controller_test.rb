require 'test_helper'

class Admin::SecretsControllerTest < ActionController::TestCase
  setup do
    @admin_secret = admin_secrets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_secrets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_secret" do
    assert_difference('Admin::Secret.count') do
      post :create, admin_secret: {  }
    end

    assert_redirected_to admin_secret_path(assigns(:admin_secret))
  end

  test "should show admin_secret" do
    get :show, id: @admin_secret
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_secret
    assert_response :success
  end

  test "should update admin_secret" do
    put :update, id: @admin_secret, admin_secret: {  }
    assert_redirected_to admin_secret_path(assigns(:admin_secret))
  end

  test "should destroy admin_secret" do
    assert_difference('Admin::Secret.count', -1) do
      delete :destroy, id: @admin_secret
    end

    assert_redirected_to admin_secrets_path
  end
end
