class AddNameToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :name, :string
  end

  def self.down
    remove_column :bills, :name
  end
end
