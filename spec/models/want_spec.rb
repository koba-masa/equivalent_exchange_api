# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Want do
  describe 'validations' do
    subject { build(:want) }

    it { is_expected.to be_valid }

    context 'when user is nil' do
      subject { build(:want, user: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when character is nil' do
      subject { build(:want, character: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when status is nil' do
      subject { build(:want, status: nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'can_cancel?' do
    context 'when status is untrading' do
      let(:want) { create(:want, status: :untrading) }

      it 'returns true' do
        want.status = :canceled
        expect(want.can_cancel?).to be true
      end
    end

    context 'when status is canceled' do
      let(:want) { create(:want, status: :canceled) }

      it 'returns true' do
        want.status = :canceled
        expect(want.can_cancel?).to be true
      end
    end

    context 'when status is trading' do
      let(:want) { create(:want, status: :trading) }

      it 'returns false' do
        want.status = :canceled
        expect(want.can_cancel?).to be false
      end
    end

    context 'when status is traded' do
      let(:want) { create(:want, status: :traded) }

      it 'returns false' do
        want.status = :canceled
        expect(want.can_cancel?).to be false
      end
    end
  end
end
