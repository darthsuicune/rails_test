require 'spec_helper'

describe "StaticPages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(content) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:content)    { 'home.html' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title ' | Home' }
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
