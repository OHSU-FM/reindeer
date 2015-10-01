require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
    test 'should redirect to 404 error handler on 404' do
        assert_routing 'non_existent_page', controller: 'errors', action: 'file_not_found', any: "non_existent_page"
    end
end
