require 'spec_helper'

describe "Micropost Pages" do
  subject { page }
  
  let (:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
      
      describe "error messages" do
        before { click_button "Post" }
        it { should have_content("error") }
      end
    end
    
    describe "with valid information" do
      before { fill_in "micropost_content", with: "Random text" }
      
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before { visit root_path }
      
      it "should delete a micropost" do
        expect { click_link "Delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
  
  describe "micropost view" do
    let(:user2) { FactoryGirl.create(:user, email: "asdfasdf@asdfasdf.asdf", name: "AAA") }
    before do 
      FactoryGirl.create(:micropost, user: user2, content: "AAAAAAAAAA")
      visit user_path(user2)
    end
    
    it { should have_content("AAAAAAAAAA") }
    it { should_not have_link("Delete") }
  end
end
