# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user, email: email) }
  let(:users) { create_list(:user, 2) }
  let(:email) { 'adf@abc.com' }
  describe '#valid?' do
    it 'is valid when email is unique' do

      expect(users.second.email).not_to be user.first.email
      expect(users.second).to be_valid
    end

    it 'is invalid if email is taken' do
      create(:user, email: 'nguyennk5@gmail.com')

      user = User.new
      user.email = 'nguyennk5@gmail.com'
      expect(user).to be_invalid
    end

    it 'is invalid if username is take' do
      user = create(:user)
      another_user = create(:user)

      expect(another_user).to be_valid
      another_user.username = user.username
      expect(another_user).to be_invalid
    end

    it "is invalid if user's first name is blank" do
      user = create(:user)
      expect(user).to be_valid

      user.first_name = ''
      expect(user).to be_invalid

      user.first_name = nil
      expect(user).to be_invalid
    end

    it 'is invalid if username is blank' do
      user = create(:user)
      expect(user).to be_valid

      user.username = ''
      expect(user).to be_invalid

      user.username = nil
      expect(user).to be_invalid
    end

    it 'is invalid if the email looks bogus' do
      user = create(:user)
      expect(user).to be_valid

      user.email = ''
      expect(user).to be_invalid

      user.email = 'nguyen.com'
      expect(user).to be_invalid

      user.email = 'nguyen.nk#gmail.com'
      expect(user).to be_invalid

      user.email = 'ng.u.y.e.n@gamil.com'
      expect(user).to be_valid

      user.email = 'nguyen+nk5@gamil.com'
      expect(user).to be_valid

      user.email = 'nguyen.nk@subdomain.gmail.com'
      expect(user).to be_valid
    end
  end

  describe '#save' do
    it 'capitalized the name correctly' do
      user = create(:user)

      user.first_name = 'NgUyEn'
      user.last_name = 'kHoI'
      user.save

      expect(user.first_name).to eq 'Nguyen'
      expect(user.last_name).to eq 'Khoi'
    end
  end
end
