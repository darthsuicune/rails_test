require 'spec_helper'

describe "StaticPages" do
  
  let(:base_title) { "Test Page" }
  
  describe "Home page" do
    it "should have the content 'home.html.erb'" do
      visit '/static_pages/home'
      expect(page).to have_content('home.html.erb')
    end
    
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title}")
    end
    
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).not_to have_title("#{base_title} | Home")
    end
  end
  
  describe "About page" do
    it "should have the content 'About us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About us')
    end
    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About")
    end
  end
  
  describe "Contact page" do
    it "should exist and have 'Contact' as a title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
  
end
