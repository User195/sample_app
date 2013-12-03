require 'spec_helper'

describe "UserPages" do
	subject { page }

	describe "SingUp page" do
		before { visit signup_path }

		it { should have_selector('h1', text: 'Sing Up') }
		it { should have_selector('title', text: full_title('Sign Up'))}
	end

	describe "Profile page" do
		let(:user) { FactoryGirl.create(:user) }
		# Code to make a user variable
		before { visit user_path(user) }

		it { should have_selector('h1',    text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "Signup" do
		before {visit signup_path }
		let(:submit) { "Create my account" }
		

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_selector('title', text: 'Sign Up')}
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in "user_name", with: "Example User"
				fill_in "user_email", with: "example@email.com"
				fill_in "user_password", with: "foobar"
				fill_in "user_password_confirmation", with: "foobar"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email('example@email.com') }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Profile', href: user_path(user)) }
				it { should have_link('Sign out', href: signout_path) }
				it { should have_link('Settings')}
				it { should_not have_link('Sign in', href: signin_path) }
			end
		end
	end
	describe "Index" do
		let(:user) { FactoryGirl.create(:user) }
		before(:each) do
			valid_signin user
			visit users_path
		end
		it { should have_selector('title', text: "All users") }
		it { should have_selector('h1', text: "All users")}
		describe "pagination" do
			it { should have_selector('div.pagination') }

			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }
			
			it "should each list user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
		end
		describe "delete links" do
			it { should_not have_link('delete') }
			describe "as un admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					valid_signin admin
					visit users_path
				end
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end
end
