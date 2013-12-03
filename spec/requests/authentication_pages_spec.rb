require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    it { should_not have_link('Settings') }
    it { should_not have_link('Profile') }

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before do
  			# valid_signin(user) method from /support/utilities.rb
  			valid_signin(user)
  		end
  		it { should have_selector('title', text: user.name) }
  		it { should have_link('Profile', href: user_path(user)) }
  		it { should have_link('Sign out', href: signout_path) }
  		it { should have_link('Settings', href: edit_user_path(user))}
  		it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Users', href: users_path)}

      describe "followed by sign up page" do
        before { visit new_user_path }
        it { should_not have_selector('h1', text: "Sign Up") }
      end

      describe "followed by create action" do
        before { post users_path }
        it { should_not have_selector('h1', text: "Sign Up") }
      end

  		describe "followed by signout" do
  			before { click_link "Sign out" }
  			it { should have_link('Sign in') }
  		end
  	end

  	describe "with invalid information" do
  		before {click_button "Sign in" }
  		it { should have_selector('title', text: 'Sign in') }
  		it { should_not have_link('Settings')}
      it { should_not have_link('Profile')}
  		it { should have_error_message('Invalid') }
  		describe "after visiting another page" do
  			before { click_link "About" }
  			it { should_not have_selector('div.alert.alert-error') }
  		end
  	end
  end

  describe "Edit information" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		valid_signin user
  		visit edit_user_path(user)
  	end
  	describe "page" do
  		it {should have_selector('h1', text: "Update your profile")}
  		it {should have_selector('title', text: "Edit user")}
  		it {should have_link('change', href: "http://gravatar.com/emails")}
  	end
  	describe "with invalid information" do
  		before {click_button "Save changes"}
  		it { should have_content('error') }
  	end
  	describe "with valid information" do
  		let(:new_name) {"New Name"}
  		let(:new_email) {"new@example.com"}
  		before do
  			fill_in "user_name", with: new_name
  			fill_in "user_email", with: new_email
  			fill_in "user_password", with: user.password
  			fill_in "user_password_confirmation", with: user.password
  			click_button "Save changes"
  		end
  		it { should have_selector('title', text: new_name) }
  		it { should have_selector('div.alert.alert-success') }
  		it { should have_link('Sign out', href: signout_path) }
  		specify { user.reload.name.should == new_name }
  		specify { user.reload.email.should == new_email }
  	end
  end

  describe "Authorization" do
    describe "As wrong user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
      before { valid_signin user }
      describe "visiting user#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end
      describe "submitting a PUT request to the user#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path)}
      end
    end
  	describe "for non-signed-in users" do
  		let(:user) { FactoryGirl.create(:user) }
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "email", with: user.email
          fill_in "password", with: user.password
          click_button "Sign in"
        end
        describe "after signed in" do
          it "page.should have_selector" do
            should have_selector('title', text: full_title('Edit user'))
          end
          describe "when signing in again" do
            before do
              delete signout_path
              valid_signin(user)
            end
            it "should render the default (profile) page" do
              should have_selector('title', text: user.name)
            end
          end
        end
      end
      describe "in the Users controller" do
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: "Sign in") }
        end
    		describe "visiting the edit page" do
    			before { visit edit_user_path(user) }
    			it { should have_selector('title', text: "Sign in") }
    		end
    		describe "submitting to the update action" do
    			# запросом PUT отправляем форму действию update
    			# response - смотрит в ответе перенаправление
    			before { put user_path(user) }
    			specify { response.should redirect_to(signin_path) }
    		end
      end
  	end
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { valid_signin non_admin }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        valid_signin admin
        visit users_path
      end
      describe "submitting a DELET request to the admin#destroy action" do
        before { delete user_path(admin) }
        # it { should have_selector('h1', text: "Welcome")}
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end