require 'spec_helper'
require_relative '../../lib/helpers/session'

include SessionHelpers

feature "User signs up" do 

  scenario "when being logged out" do 
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email)
  end

  scenario "with a password that doesn't match" do 
    expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do 
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken") 
  end

end

feature "User signs in" do 

  before(:each) do 
    User.create(:email => "test@test.com", 
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "with correct credentials" do 
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do 
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User signs out' do 

  before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario 'while being signed in' do 
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Goodbye")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end


feature 'User forgets password' do 

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test',
                :password_token => 'YYNUZHNGHCCOEZEJFVNEBZCIZRWOXIZSWZDEYMNOVYSVTJTSRKKPNICUXINOCEVX')
  end

  scenario 'and decides to reset it' do 
    visit 'sessions/new'
    click_link "forgot_password"
    expect(page).to have_content('Please enter your email')
    fill_in('email', :with => "test@test.com")
    click_button("I forgot my password")
    expect(page).to have_content('Please check your email')
  end

  scenario 'and resets password' do 
    visit '/users/reset_password/YYNUZHNGHCCOEZEJFVNEBZCIZRWOXIZSWZDEYMNOVYSVTJTSRKKPNICUXINOCEVX'
    expect(page).to have_content('Please enter a new password below.')
    fill_in('password', :with => 'newone')
    fill_in('password_confirmation', :with => 'newone')
    click_button("Reset Password")
    expect(page).to have_content('Password successfully reset.')
  end

end

