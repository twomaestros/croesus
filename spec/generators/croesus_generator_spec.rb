require 'rails_helper'
require 'rails/generators'
require 'generators/croesus/croesus_generator'

describe Croesus::Generators::CroesusGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)
  
  before do
    prepare_destination
    copy_routes
    run_generator %w(baklava)
  end
  
  describe 'the authentication credentials migration' do
    subject { migration_file 'db/migrate/croesus_create_auth_credentials.rb' }
    
    it 'exists' do
      expect(subject).to exist
    end
  end
  
  describe 'the authenticatable model' do
    subject { file 'app/models/baklava.rb' }
    
    it 'exists' do
      expect(subject).to exist
    end
    
    it 'contains the croesus command' do
      expect(subject).to contain /^  croesus$/
    end
  end
  
  describe 'the routes file' do
    subject { file 'config/routes.rb' }
    
    it 'contains croesus_for :baklava' do
      expect(subject).to contain /croesus_for :baklava/
    end
  end
  
  describe 'the initializer' do
    subject { file 'config/initializers/croesus.rb' }
    
    it 'exists' do
      expect(subject).to exist
    end
  end
  
  def copy_routes
    routes = File.expand_path("../../../spec/test_app/config/routes.rb", __FILE__)
    destination = File.join(destination_root, "config")

    FileUtils.mkdir_p(destination)
    FileUtils.cp routes, destination
  end
end