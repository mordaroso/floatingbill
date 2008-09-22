class Category < ActiveRecord::Base
  has_many :bills

  def self.find_by_name_like(name)
    self.find(:all, :conditions => ['categories.name LIKE ?', "#{name}%" ])
  end
end

