include ApplicationHelper

def valid_signin(user)
	visit signin_path
	fill_in "email",    with: user.email.upcase
	fill_in "password", with: user.password
	click_button "Sign in"
	# Вход без CapyBara
	cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

