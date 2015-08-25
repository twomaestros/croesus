require 'test_helper'
require "generators/croesus/croesus_generator"

class CroesusGeneratorTest < Rails::Generators::TestCase
  tests Croesus::Generators::CroesusGenerator
  destination File.expand_path("../../tmp", __FILE__)

  setup do
    prepare_destination
    copy_routes
  end

  test "route generation for simple model names" do
    run_generator %w(monster name:string)
    assert_file "config/routes.rb", /croesus_for :monsters/
  end

  test "route generation for namespaced model names" do
    run_generator %w(monster/goblin name:string)
    match = /croesus_for :goblins, class_name: "Monster::Goblin"/
    assert_file "config/routes.rb", match
  end

  test "route generation with skip routes" do
    run_generator %w(monster name:string --skip-routes)
    match = /croesus_for :monsters, skip: :all/
    assert_file "config/routes.rb", match
  end

  def copy_routes
    routes = File.expand_path("../../test_app/config/routes.rb", __FILE__)
    destination = File.join(destination_root, "config")

    FileUtils.mkdir_p(destination)
    FileUtils.cp routes, destination
  end
end
