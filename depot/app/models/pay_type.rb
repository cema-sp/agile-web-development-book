class PayType < ActiveRecord::Base
	self.inheritance_column = :inh_type
	
	has_many :orders
end
