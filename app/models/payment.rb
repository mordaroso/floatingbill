class Payment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payer, :class_name => "User" ,:foreign_key => "user_id"

end
