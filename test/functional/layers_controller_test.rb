require 'test_helper'

class LayersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:layers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create layer" do
    assert_difference('Layer.count') do
      post :create, :layer => { }
    end

    assert_redirected_to layer_path(assigns(:layer))
  end

  test "should show layer" do
    get :show, :id => layers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => layers(:one).to_param
    assert_response :success
  end

  test "should update layer" do
    put :update, :id => layers(:one).to_param, :layer => { }
    assert_redirected_to layer_path(assigns(:layer))
  end

  test "should destroy layer" do
    assert_difference('Layer.count', -1) do
      delete :destroy, :id => layers(:one).to_param
    end

    assert_redirected_to layers_path
  end
end
