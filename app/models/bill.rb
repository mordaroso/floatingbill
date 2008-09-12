class Bill < ActiveRecord::Base
  has_many :payments
  belongs_to :category
end
