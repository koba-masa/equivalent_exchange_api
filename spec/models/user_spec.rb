# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  # ユーザに対するバリデーションのテストをrspecで書く
  describe 'validation' do
    subject { build(:user) }

    it { is_expected.to be_valid }

    context 'when password similar password_confirmation' do
      subject { build(:user, password: 'password', password_confirmation: 'password') }

      it { is_expected.to be_valid }
    end

    context 'when login_id is nil' do
      subject { build(:user, login_id: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when login_id is too long' do
      subject { build(:user, login_id: 'a' * 129) }

      it { is_expected.to be_invalid }
    end

    context 'when password is nil' do
      subject { build(:user, password: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when display_name is nil' do
      subject { build(:user, display_name: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when display_name is too long' do
      subject { build(:user, display_name: 'a' * 129) }

      it { is_expected.to be_invalid }
    end

    context 'when email is nil' do
      subject { build(:user, email: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when email is too long' do
      subject { build(:user, email: 'a' * 513) }

      it { is_expected.to be_invalid }
    end

    context 'when login_id is not unique' do
      subject { build(:user, login_id: 'test_user') }

      before { create(:user, login_id: 'test_user') }

      it { is_expected.to be_invalid }
    end

    context 'when email is not unique' do
      subject { build(:user, email: 'testuser@sample.com') }

      before { create(:user, email: 'testuser@sample.com') }

      it { is_expected.to be_invalid }
    end

    context 'when password differ password_confirmation' do
      subject { build(:user, password: 'password', password_confirmation: 'invalid_password') }

      it { is_expected.to be_invalid }
    end
  end
end
