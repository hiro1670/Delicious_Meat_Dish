require "test_helper"

class Public::TagsearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get public_tagsearches_search_url
    assert_response :success
  end
end
