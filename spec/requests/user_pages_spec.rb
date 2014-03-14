require 'spec_helper'

describe "UserPages" do
    
  subject { page }

  describe "Signup page" do
    before { visit signup_path }
    
    let(:submit) { "Create" }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
    
    describe "with invalid information" do
      it "doesn't modify user count" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title("Sign up") }
        it { should have_content("Email can't be blank") }
        it { should have_content("Name can't be blank") }
        it { should have_content("Password is too short") }
        it { should have_content("Password confirmation can't") }
        it { should_not have_content("Password digest can't be blank") }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name", with: "User"
        fill_in "Surname", with: "Suruser"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end
      
      it "should increase user count by 1" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
  
end
