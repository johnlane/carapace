require File.dirname(__FILE__) + '/../test_helper'

class MessageControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success
  end 

end

