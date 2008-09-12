class Payment < ActiveRecord::Base
  belongs_to :bill
end
