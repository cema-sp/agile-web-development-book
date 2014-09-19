class Order < ActiveResource::Base
	self.site = 'http://Cema:cema@127.0.0.1:3000/'

	has_many :line_items
end
