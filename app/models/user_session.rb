class UserSession < Authlogic::Session::Base
  # attr_accessible :title, :body
  generalize_credentials_error_messages true
end
