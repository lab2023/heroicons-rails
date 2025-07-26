require "test_helper"

class Heroicons::RailsTest < ActiveSupport::TestCase
  include Heroicons::ApplicationHelper

  # Mock Rails' raw helper for testing
  def raw(content)
    content.html_safe
  end

  test "it has a version number" do
    assert Heroicons::VERSION
  end

  test "icon_tag works with dash format string names" do
    result = icon_tag("academic-cap")

    assert result.include?('class="w-6 h-6"'), "Should include default classes"
    assert result.include?("<svg"), "Should contain SVG markup"
    assert_not result.include?("Icon Not Found"), "Should find the icon file"
  end

  test "icon_tag works with different icon types" do
    # Test outline (default)
    outline_result = icon_tag("academic-cap", type: :outline)
    assert outline_result.include?("<svg"), "Outline icon should render"

    # Test solid
    solid_result = icon_tag("academic-cap", type: :solid)
    assert solid_result.include?("<svg"), "Solid icon should render"
  end

  test "icon_tag converts symbol to string" do
    symbol_result = icon_tag(:"academic-cap")
    string_result = icon_tag("academic-cap")

    # Both should work and produce similar results
    assert symbol_result.include?("<svg"), "Symbol parameter should work"
    assert string_result.include?("<svg"), "String parameter should work"
  end

  test "icon_tag applies custom CSS classes" do
    result = icon_tag("academic-cap", class: "custom-class text-red-500")

    assert result.include?('class="custom-class text-red-500"'), "Should apply custom classes"
  end

  test "icon_tag raises error for non-existent icons" do
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon")
    end

    assert_equal "non-existent-icon", error.icon_name
    assert_equal :outline, error.icon_type
    assert error.searched_paths.any? { |path| path.include?("non-existent-icon.svg") }
    assert error.message.include?("Icon 'non-existent-icon' of type 'outline' not found")
  end

  test "icon_tag raises error with correct type for non-existent icons" do
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon", type: :solid)
    end

    assert_equal "non-existent-icon", error.icon_name
    assert_equal :solid, error.icon_type
  end

  test "icon_tag works with more dash format icons" do
    [
      "x-mark",
      "chevron-left",
      "arrow-left-circle",
      "document-plus"
    ].each do |icon_name|
      result = icon_tag(icon_name)
      assert result.include?("<svg"), "Icon #{icon_name} should render successfully"
      assert_not result.include?("Icon Not Found"), "Icon #{icon_name} should be found"
    end
  end

  test "icon_tag preserves dash format in file paths" do
    # This test ensures we're not converting dashes to underscores
    result = icon_tag("academic-cap")

    # Icon should be found and rendered correctly
    assert result.include?("<svg"), "Should render SVG when icon is found"
    assert result.include?('class="w-6 h-6"'), "Should include default classes"
  end

  test "icon_tag error message preserves dash format" do
    # Test that error messages show dash format, not underscore
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("fake-icon-name")
    end

    assert error.searched_paths.any? { |path| path.include?("fake-icon-name.svg") }
    assert_not error.searched_paths.any? { |path| path.include?("fake_icon_name.svg") }
  end

  test "icon_tag supports underscored names with conversion" do
    # Use underscored icon name - should work by converting to dash
    result = icon_tag("academic_cap")

    # Should render the icon (converts underscore to dash)
    assert result.include?("<svg"), "Should render SVG even with underscored name"
    assert result.include?('class="w-6 h-6"'), "Should include default classes"

    # The icon should be found because academic_cap -> academic-cap conversion works
    assert_not result.include?("Icon Not Found"), "Should find icon after underscore to dash conversion"
  end
end
