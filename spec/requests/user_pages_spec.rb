require 'spec_helper'

describe "User pages" do
    
  subject { page }

  describe "Signup page" do
    before { visit signup_path }
    
    let(:submit) { "Create" }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
    
    describe "with invalid information" do
      it "won't modify user count" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title("Sign up") }
        it { should have_content("Email can't be blank") }
        it { should have_content("Name can't be blank") }
        it { should have_content("Password is too short") }
        it { should have_content("Password confirmation can't be blank") }
        it { should_not have_content("Password digest can't be blank") }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name", with: "User"
        fill_in "Surname", with: "Suruser"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm password", with: "foobar"
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
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link("Change", href: 'http://gravatar.com/emails') }
    end
    
    describe "with invalid information" do
      before { click_button "Save changes" }
      
      it { should have_content("error") }
    end
    
    describe "with valid information" do
      let(:new_name) { "New" }
      let(:new_surname) { "Name" }
      let(:new_email) { "new@example.com" }
      
      before do
        fill_in "Name", with: new_name
        fill_in "Surname", with: new_surname
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_title(new_name) }
      it { should have_selector("div.alert.alert-success") }
      it { should have_link("Sign out", href: signout_path) }
      
      specify { user.reload.name.should == new_name }
      specify { user.reload.surname.should == new_surname }
      specify { user.reload.email.should == new_email }
    end
  end
  
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Name1", email: "name1@example.org")
      FactoryGirl.create(:user, name: "Name2", email: "name2@example.org")
      visit users_path
    end
    
    it { should have_title("All users") }
    it { should have_content("All users") }
    
    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      it { should_not have_link("delete") }
      
      describe "as an admin users" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link("Delete", href: user_path(User.first)) }
        it "should be able to delete another user" do
          Capybara.match = :first
          expect { click_link("Delete") }.to change(User, :count).by(-1)
        end
        it { should_not have_link("Delete", href: user_path(admin)) }
      end
      
      describe "as nonadmin users" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }
  
        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
  end
end
