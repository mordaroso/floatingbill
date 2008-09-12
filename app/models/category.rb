class Category < ActiveRecord::Base
  has_many :bills
end
