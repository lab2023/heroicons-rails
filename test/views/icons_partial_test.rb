class IconsPartialTest < ActionView::TestCase
  test "should not be blank name" do
    render "components/icons", name: ""

    assert_includes rendered, "Icon Not Found!"
  end

  test "render a icon" do
    render "components/icons", name: "academic_cap", outline: :micro

    assert_not_includes rendered, "Icon Not Found!"
  end
end
