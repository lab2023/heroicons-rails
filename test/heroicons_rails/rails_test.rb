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

  test "icon_tag handles non-existent icons gracefully" do
    result = icon_tag("non-existent-icon")

    assert result.include?("Icon Not Found"), "Should show error message for missing icons"
    assert result.include?("non-existent-icon.svg"), "Should show the attempted path"
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

    # If there's an error, it should show dash format in the path
    if result.include?("Icon Not Found")
      assert result.include?("academic-cap.svg"), "Error message should show dash format"
      assert_not result.include?("academic_cap.svg"), "Should not convert to underscore"
    end
  end
end
