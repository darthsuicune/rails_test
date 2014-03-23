require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(content) }
    it { should have_title(full_title(page_title)) }
  end

  describe "home page" do
    before { visit root_path }
    let(:content)    { 'ZOMBI' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title ' | Home' }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Random text")
        FactoryGirl.create(:micropost, user: user, content: "I've already seen this")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      it { should have_content("micropost".pluralize(user.microposts.count)) }
      
      describe "feed pagination" do
        before(:each) do
          100.times { FactoryGirl.create(:micropost, user: user, content: "Afqfenj") }
          sign_in user
          visit root_path
        end
        after(:all) { user.microposts.delete_all }
        
        it { should have_selector('div.pagination') }
        it "should list each micropost" do
          user.microposts.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: "A")
          end
        end
      end
    end
  end
  
  describe "About page" do
    before { visit about_path }
    let(:content)    { 'About us' }
    let(:page_title) { 'About' }
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    let(:content)    { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end
  
  it "should have the right links on the layout" do
    visit root_path
    Capybara.match = :first
    click_link "About"
    page.should have_title(full_title('About'))
    click_link "Contact"
    page.should have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    page.should have_title(full_title('Sign up'))
    click_link "First test"
    page.should have_title(full_title(''))
  end
end
