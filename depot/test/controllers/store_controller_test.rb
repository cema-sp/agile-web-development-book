require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select '#side .time', /\d{2}.\d{2}.\d{4}.*\d{2}\:\d{2}/
    assert_select '#main .entry', 3
    assert_select 'h3', 'Jasmine Oolong Tea'
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

end
