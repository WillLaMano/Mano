require 'test_helper'

module AuthorizationsTestHelper
    def check_correct_url(provider,auth) 
      post :create, :provider=>provider
      assert_redirected_to auth.access_url, "Redirect to #{provider} Access URL"
    end
end
