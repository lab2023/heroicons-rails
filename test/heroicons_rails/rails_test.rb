require "test_helper"

class Heroicons::RailsTest < ActiveSupport::TestCase
  include Heroicons::ApplicationHelper

  # Mock Rails' raw helper for testing
  def raw(content)
    content
  end

  test "it has a version number" do
    assert Heroicons::VERSION
  end

  test "icon_tag works with dash format string names" do
    result = icon_tag("academic-cap")

    assert_includes result, 'class="w-6 h-6"', "Should include default classes"
    assert_includes result, "<svg", "Should contain SVG markup"
    assert_not result.include?("Icon Not Found"), "Should find the icon file"
  end

  test "icon_tag works with different icon types" do
    # Test outline (default)
    outline_result = icon_tag("academic-cap", type: :outline)

    assert_includes outline_result, "<svg", "Outline icon should render"

    # Test solid
    solid_result = icon_tag("academic-cap", type: :solid)

    assert_includes solid_result, "<svg", "Solid icon should render"
  end

  test "icon_tag converts symbol to string" do
    symbol_result = icon_tag(:"academic-cap")
    string_result = icon_tag("academic-cap")

    # Both should work and produce similar results
    assert_includes symbol_result, "<svg", "Symbol parameter should work"
    assert_includes string_result, "<svg", "String parameter should work"
  end

  test "icon_tag applies custom CSS classes" do
    result = icon_tag("academic-cap", class: "custom-class text-red-500")

    assert_includes result, 'class="custom-class text-red-500"', "Should apply custom classes"
  end

  test "icon_tag raises error for non-existent icons" do
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon")
    end

    assert_equal "non-existent-icon", error.icon_name
    assert_equal :outline, error.icon_type
  end

  test "icon_tag error contains correct paths and message" do
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon")
    end

    assert(error.searched_paths.any? { |path| path.include?("non-existent-icon.svg") })
    assert_includes error.message, "Icon 'non-existent-icon' of type 'outline' not found"
  end

  test "icon_tag raises error with correct type for non-existent icons" do
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon", type: :solid)
    end

    assert_equal "non-existent-icon", error.icon_name
    assert_equal :solid, error.icon_type
  end

  test "icon_tag works with more dash format icons" do
    %w[
      x-mark
      chevron-left
      arrow-left-circle
      document-plus
    ].each do |icon_name|
      result = icon_tag(icon_name)

      assert_includes result, "<svg", "Icon #{icon_name} should render successfully"
      assert_not result.include?("Icon Not Found"), "Icon #{icon_name} should be found"
    end
  end

  test "icon_tag preserves dash format in file paths" do
    # This test ensures we're not converting dashes to underscores
    result = icon_tag("academic-cap")

    # Icon should be found and rendered correctly
    assert_includes result, "<svg", "Should render SVG when icon is found"
    assert_includes result, 'class="w-6 h-6"', "Should include default classes"
  end

  test "icon_tag error message preserves dash format" do
    # Test that error messages show dash format, not underscore
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("fake-icon-name")
    end

    assert(error.searched_paths.any? { |path| path.include?("fake-icon-name.svg") })
    assert_not(error.searched_paths.any? { |path| path.include?("fake_icon_name.svg") })
  end

  test "icon_tag supports underscored names with conversion" do
    # Use underscored icon name - should work by converting to dash
    result = icon_tag("academic_cap")

    # Should render the icon (converts underscore to dash)
    assert_includes result, "<svg", "Should render SVG even with underscored name"
    assert_includes result, 'class="w-6 h-6"', "Should include default classes"

    # The icon should be found because academic_cap -> academic-cap conversion works
    assert_not result.include?("Icon Not Found"), "Should find icon after underscore to dash conversion"
  end

  test "icon_tag uses default configuration values" do
    Heroicons.reset_configuration!

    result = icon_tag("academic-cap")

    assert_includes result, 'class="w-6 h-6"', "Should use default class from configuration"
    assert_includes result, "<svg", "Should render outline icon by default"
  end

  test "icon_tag uses custom default_class from configuration" do
    Heroicons.configure do |config|
      config.default_class = "w-8 h-8 text-blue-500"
    end

    result = icon_tag("academic-cap")

    assert_includes result, 'class="w-8 h-8 text-blue-500"', "Should use configured default_class"
  ensure
    Heroicons.reset_configuration!
  end

  test "icon_tag uses custom default_type from configuration" do
    Heroicons.configure do |config|
      config.default_type = :solid
    end

    # Request non-existent icon to check which type is being searched
    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon")
    end

    assert_equal :solid, error.icon_type, "Should use configured default_type"
  ensure
    Heroicons.reset_configuration!
  end

  test "icon_tag option overrides configured default_type" do
    Heroicons.configure do |config|
      config.default_type = :solid
    end

    error = assert_raises(Heroicons::IconNotFoundError) do
      icon_tag("non-existent-icon", type: :mini)
    end

    assert_equal :mini, error.icon_type, "Explicit type option should override configuration"
  ensure
    Heroicons.reset_configuration!
  end

  test "icon_tag option overrides configured default_class" do
    Heroicons.configure do |config|
      config.default_class = "w-8 h-8"
    end

    result = icon_tag("academic-cap", class: "custom-override")

    assert_includes result, 'class="custom-override"', "Explicit class option should override configuration"
  ensure
    Heroicons.reset_configuration!
  end

  test "configuration reset restores default values" do
    Heroicons.configure do |config|
      config.default_type = :mini
      config.default_class = "w-10 h-10"
    end

    Heroicons.reset_configuration!

    assert_equal :outline, Heroicons.configuration.default_type
    assert_equal "w-6 h-6", Heroicons.configuration.default_class
  end
end
