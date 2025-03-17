require 'rails_helper'
require 'fileutils'

RSpec.describe "Backup Script", type: :system do
  let(:backup_dir) { Rails.root.join("backups") }
  
  before do
    FileUtils.mkdir_p(backup_dir)  # Ensure the backup directory exists
    allow(Time).to receive(:now).and_return(Time.new(2025, 3, 16, 12, 0, 0)) # Freeze time for consistent filenames
  end

  after do
    FileUtils.rm_rf(backup_dir) # Clean up backups after test
  end

  it "creates a new backup file" do
    system("./backup.sh")
    
    backup_files = Dir.glob("#{backup_dir}/backup-*.sql")
    expect(backup_files).not_to be_empty
  end

  it "deletes backups older than 24 hours" do
    # Create an old backup file
    old_backup = backup_dir.join("backup-old.sql")
    FileUtils.touch(old_backup, mtime: Time.now - (25 * 60 * 60)) # Set mtime to 25 hours ago

    expect(File.exist?(old_backup)).to be_truthy # Ensure old file exists

    # Run the backup script
    system("./backup.sh")

    expect(File.exist?(old_backup)).to be_falsey # Old file should be deleted
  end
end
