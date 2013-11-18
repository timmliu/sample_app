require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
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
        expect { click_link "delete"}.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "displaying correct number of microposts in sidebar" do

    describe "for 0 microposts" do
      before { visit root_path }
      it { should have_content("0 microposts") }
    end

    describe "for 1 micropost" do
      before do
        FactoryGirl.create(:micropost, user: user)
        visit root_path
      end
      it { should have_content("1 micropost") }
    end

    describe "for 2+ microposts" do
      before do
        10.times { FactoryGirl.create(:micropost, user: user) }
        visit root_path
      end
      it { should have_content("10 microposts") }
    end
  end

  describe "paginating the feed correctly" do
    before do
      50.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    it { should have_selector("div.pagination") }
  end
end