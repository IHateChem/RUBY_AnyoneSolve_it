require "application_system_test_case"

class TestmsTest < ApplicationSystemTestCase
  setup do
    @testm = testms(:one)
  end

  test "visiting the index" do
    visit testms_url
    assert_selector "h1", text: "Testms"
  end

  test "should create testm" do
    visit testms_url
    click_on "New testm"

    fill_in "Ids", with: @testm.ids
    fill_in "Name", with: @testm.name
    fill_in "Password", with: @testm.password
    click_on "Create Testm"

    assert_text "Testm was successfully created"
    click_on "Back"
  end

  test "should update Testm" do
    visit testm_url(@testm)
    click_on "Edit this testm", match: :first

    fill_in "Ids", with: @testm.ids
    fill_in "Name", with: @testm.name
    fill_in "Password", with: @testm.password
    click_on "Update Testm"

    assert_text "Testm was successfully updated"
    click_on "Back"
  end

  test "should destroy Testm" do
    visit testm_url(@testm)
    click_on "Destroy this testm", match: :first

    assert_text "Testm was successfully destroyed"
  end
end
