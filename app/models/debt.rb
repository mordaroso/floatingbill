class Debt < ActiveRecord::Base
  belongs_to :creditor, :class_name => "User" , :foreign_key => "creditor_id"
  belongs_to :debitor, :class_name => "User" , :foreign_key => "debitor_id"
end
