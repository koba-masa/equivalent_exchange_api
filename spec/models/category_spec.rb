# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  describe 'validations' do
    subject { build(:category) }

    it { is_expected.to be_valid }

    context 'when name is nil' do
      subject { build(:category, name: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when name is too long' do
      subject { build(:category, name: 'a' * 129) }

      it { is_expected.to be_invalid }
    end

    context 'when name is not unique' do
      subject { build(:category, name: 'カテゴリー') }

      before { create(:category, name: 'カテゴリー') }

      it { is_expected.to be_invalid }
    end
  end
end
