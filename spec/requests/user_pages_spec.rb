require 'spec_helper'

describe "UserPages" do
	subject { page }

	describe "SingUp page" do
		before { visit singup_path }

		it { should have_selector('h1', text: 'Sing Up') }
		it { should have_selector('title', text: full_title('Sing Up'))}
	end
end
