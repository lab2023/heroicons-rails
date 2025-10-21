require "test_helper"

class Heroicons::IconScannerTest < ActiveSupport::TestCase
  test "scans icon_tag calls with icon names" do
    scanner = Heroicons::IconScanner.new(Rails.root)
    content = <<~RUBY
      <%= icon_tag :home %>
      <%= icon_tag "user" %>
      <%= icon_tag :x_mark, type: :solid %>
    RUBY

    used_icons = Hash.new { |h, k| h[k] = Set.new }
    scanner.send(:extract_icons_from_content, content, used_icons)

    assert_includes used_icons[:outline], "home"
    assert_includes used_icons[:outline], "user"
    assert_includes used_icons[:solid], "x-mark" # Should normalize underscores
  end

  test "normalizes underscored icon names to dashes" do
    scanner = Heroicons::IconScanner.new(Rails.root)
    content = "<%= icon_tag :academic_cap %>"

    used_icons = Hash.new { |h, k| h[k] = Set.new }
    scanner.send(:extract_icons_from_content, content, used_icons)

    assert_includes used_icons[:outline], "academic-cap"
    assert_not_includes used_icons[:outline], "academic_cap"
  end

  test "detects icon types correctly" do
    scanner = Heroicons::IconScanner.new(Rails.root)
    content = <<~RUBY
      <%= icon_tag :home %>
      <%= icon_tag :check, type: :solid %>
      <%= icon_tag :star, type: :mini %>
      <%= icon_tag :bell, type: :micro %>
    RUBY

    used_icons = Hash.new { |h, k| h[k] = Set.new }
    scanner.send(:extract_icons_from_content, content, used_icons)

    assert_includes used_icons[:outline], "home"
    assert_includes used_icons[:solid], "check"
    assert_includes used_icons[:mini], "star"
    assert_includes used_icons[:micro], "bell"
  end

  test "handles various syntax formats" do
    scanner = Heroicons::IconScanner.new(Rails.root)
    content = <<~RUBY
      <%= icon_tag(:home) %>
      <%= icon_tag :user, class: "w-4 h-4" %>
      <%= icon_tag "settings" %>
      <%= icon_tag("menu") %>
    RUBY

    used_icons = Hash.new { |h, k| h[k] = Set.new }
    scanner.send(:extract_icons_from_content, content, used_icons)

    assert_includes used_icons[:outline], "home"
    assert_includes used_icons[:outline], "user"
    assert_includes used_icons[:outline], "settings"
    assert_includes used_icons[:outline], "menu"
  end

  test "returns empty hash on scan error" do
    scanner = Heroicons::IconScanner.new("/nonexistent/path")
    result = scanner.scan_used_icons

    assert_equal({}, result)
  end
end
