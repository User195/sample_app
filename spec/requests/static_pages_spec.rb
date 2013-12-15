require 'spec_helper'

describe "Static pages" do
  subject { page }
  #Создаёт переменную соответствующую своему агрументу
  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  shared_examples_for "all static pages" do
    it {should have_selector('h1', text: heading)}
    it {should have_selector('title', text: full_title(page_title))}
  end

  describe "Home page" do
    before {visit root_path}
    let(:heading) {'Sample App'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: "| Home") }
    it "should have the right links on the layout" do
      click_link "Home"
      click_link "Contact"
      click_link "Help"
      click_link "Sign in"
      click_link "sample app"
      click_link "Sign up now!"
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item| 
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "feed microposts" do
        # проверка количества микропостов
        it { should have_content(user.microposts.count) }

        describe "pagination" do
          it { should have_selector('div.pagination') }

          before(:all) { 30.times { FactoryGirl.create(:micropost, user: user, content: "test") } }
          after(:all) { User.delete_all }
          
          it "should each list user" do
            User.paginate(page: 1).each do |user|
              page.should have_selector('li', text: user.name)
            end
          end
        end
      end

      describe "follower/followed counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) {'About'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
  end
end