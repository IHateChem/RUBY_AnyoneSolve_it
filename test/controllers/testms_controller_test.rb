require "test_helper"

class TestmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @testm = testms(:one)
  end

  test "should get index" do
    get testms_url
    assert_response :success
  end

  test "should get new" do
    get new_testm_url
    assert_response :success
  end

  test "should create testm" do
    assert_difference("Testm.count") do
      post testms_url, params: { testm: { ids: @testm.ids, name: @testm.name, password: @testm.password } }
    end

    assert_redirected_to testm_url(Testm.last)
  end

  test "should show testm" do
    get testm_url(@testm)
    assert_response :success
  end

  test "should get edit" do
    get edit_testm_url(@testm)
    assert_response :success
  end

  test "should update testm" do
    patch testm_url(@testm), params: { testm: { ids: @testm.ids, name: @testm.name, password: @testm.password } }
    assert_redirected_to testm_url(@testm)
  end

  test "should destroy testm" do
    assert_difference("Testm.count", -1) do
      delete testm_url(@testm)
    end

    assert_redirected_to testms_url
  end
end
