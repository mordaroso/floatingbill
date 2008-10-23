class AddRssHashToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :rss_hash, :string, :limit => 40
  end

  def self.down
    remove_column :users, :rss_hash
  end
end
