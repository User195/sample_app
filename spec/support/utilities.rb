include ApplicationHelper

def valid_signin(user)
  fill_in "session_email",    with: user.email.upcase
  fill_in "session_password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end