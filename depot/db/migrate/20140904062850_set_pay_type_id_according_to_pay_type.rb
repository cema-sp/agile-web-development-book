class SetPayTypeIdAccordingToPayType < ActiveRecord::Migration
  def up
  	Order.all.each do |order|
  		pay_type = PayType.find_by_type(order[:pay_type])
  		order.pay_type_id = pay_type[:id]
  		order.save
  	end
  end
  def down
  	Order.all.each do |order|
  		order.pay_type_id = nil
  		order.save
  	end
  end
end
