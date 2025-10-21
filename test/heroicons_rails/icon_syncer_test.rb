require "test_helper"
require "fileutils"
require "tmpdir"
require "minitest/mock"

class Heroicons::IconSyncerTest < ActiveSupport::TestCase
  def setup
    @temp_dir = Dir.mktmpdir
    @mock_scanner = Minitest::Mock.new
  end

  def teardown
    FileUtils.rm_rf(@temp_dir) if @temp_dir && Dir.exist?(@temp_dir)
  end

  test "dry_run returns report without making changes" do
    @mock_scanner.expect(:scan_used_icons, { outline: ["home", "user"] })

    syncer = Heroicons::IconSyncer.new(@temp_dir, scanner: @mock_scanner)
    report = syncer.dry_run

    assert_respond_to report, :[]
    assert_includes report.keys, :would_copy
    assert_includes report.keys, :would_remove
    assert_includes report.keys, :would_keep

    @mock_scanner.verify
  end

  test "sync! returns stats with counts" do
    @mock_scanner.expect(:scan_used_icons, {})

    syncer = Heroicons::IconSyncer.new(@temp_dir, scanner: @mock_scanner)
    stats = syncer.sync!

    assert_respond_to stats, :[]
    assert_includes stats.keys, :copied
    assert_includes stats.keys, :removed
    assert_includes stats.keys, :kept
    assert_includes stats.keys, :errors

    @mock_scanner.verify
  end

  test "gem_icons_path returns correct path" do
    syncer = Heroicons::IconSyncer.new(@temp_dir)
    path = syncer.send(:gem_icons_path, :outline)

    assert_includes path, "app/assets/images/icons/outline"
    assert_includes path, Heroicons.root
  end

  test "app_icons_path returns correct path" do
    syncer = Heroicons::IconSyncer.new(@temp_dir)
    path = syncer.send(:app_icons_path, :solid)

    assert_includes path, "app/assets/images/icons/solid"
    assert_includes path, @temp_dir
  end

  test "existing_app_icons returns empty array for nonexistent directory" do
    syncer = Heroicons::IconSyncer.new(@temp_dir)
    icons = syncer.send(:existing_app_icons, :outline)

    assert_equal [], icons
  end

  test "existing_app_icons returns svg files from directory" do
    icons_dir = File.join(@temp_dir, "app/assets/images/icons/outline")
    FileUtils.mkdir_p(icons_dir)
    FileUtils.touch(File.join(icons_dir, "home.svg"))
    FileUtils.touch(File.join(icons_dir, "user.svg"))
    FileUtils.touch(File.join(icons_dir, "readme.txt")) # Should be ignored

    syncer = Heroicons::IconSyncer.new(@temp_dir)
    icons = syncer.send(:existing_app_icons, :outline)

    assert_equal 2, icons.size
    assert_includes icons, "home.svg"
    assert_includes icons, "user.svg"
    assert_not_includes icons, "readme.txt"
  end
end
