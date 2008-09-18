class AddCreatorToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :creator_id, :integer
  end

  def self.down
    remove_column :bills, :creator_id
  end
end
