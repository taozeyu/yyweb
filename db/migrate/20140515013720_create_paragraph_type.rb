class CreateParagraphType < ActiveRecord::Migration
  def self.up
    add_column :paragraphs, :paragraph_type, :integer, :limit => 8, :null => false, :default => 1
  end

  def self.down
  end
end
