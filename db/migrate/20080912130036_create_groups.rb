class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name,                     :string, :limit => 40
      t.column :description,              :string, :limit => 255, :default => ''
      t.timestamps
    end
    create_table :memberships do |t|
      t.column :group_id,                 :integer
      t.column :user_id,                  :integer
      t.column :created_at,               :datetime
    end
  end

  def self.down
    drop_table :groups
    drop_table :memberships
  end
end
