require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
    mail = OrderNotifier.received(orders(:daves_order))
    assert_equal "Cema's Tea Shop order notification", mail.subject
    assert_equal [orders(:daves_order)[:email]], mail.to
    assert_equal ["cema@example.com"], mail.from
    assert_match /2 x Jasmine Oolong Tea/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:daves_order))
    assert_equal "Cema's Tea Shop order shipped", mail.subject
    assert_equal [orders(:daves_order)[:email]], mail.to
    assert_equal ["cema@example.com"], mail.from
    assert_match /<td>2 &times; <\/td>\s*\s<td>Jasmine Oolong Tea<\/td>/, mail.body.encoded
  end

end