class ChangeChangePostTitleLimit < ActiveRecord::Migration
  def self.up
    change_column :posts, :title, :string, :limit => 120
  end

  def self.down
    change_column :posts, :title, :string, :limit => 40
  end
end
