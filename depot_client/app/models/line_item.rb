class LineItem < ActiveResource::Base
	self.site = 'http://Cema:cema@127.0.0.1:3000/'

	belongs_to :order
	belongs_to :product
end
