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

  describe 'status_label' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  describe 'candidate_stocks' do
    let(:user) { create(:user, display_name: 'テスト用ユーザ') }
    let(:another_user1) { create(:user, display_name: '別ユーザ1') }
    let(:another_user2) { create(:user, display_name: '別ユーザ2') }

    let(:category) { create(:category, name: 'カテゴリ1') }
    let(:good) { create(:good, name: 'グッズ1', category:) }
    let(:character1) { create(:character, name: 'キャラクター1', good:) }
    let(:character2) { create(:character, name: 'キャラクター2', good:) }
    let(:character3) { create(:character, name: 'キャラクター3', good:) }

    let(:user_stock_untrading) { create(:want, user:, character: character1, status: 0) }
    let(:user_stock_canceled) { create(:stock, user:, character: character1, status: 10) }
    let(:user_stock_trading) { create(:stock, user:, character: character1, status: 20) }
    let(:user_stock_traded) { create(:stock, user:, character: character1, status: 30) }

    let(:another_user1_stock_untrading1) { create(:stock, user: another_user1, character: character1, status: 0) }
    let(:another_user1_stock_untrading2) { create(:stock, user: another_user1, character: character1, status: 0) }
    let(:another_user1_stock_untrading3) { create(:stock, user: another_user1, character: character1, status: 0) }
    let(:another_user1_stock_canceled) { create(:stock, user: another_user1, character: character1, status: 10) }
    let(:another_user1_stock_trading) { create(:stock, user: another_user1, character: character1, status: 20) }
    let(:another_user1_stock_traded) { create(:stock, user: another_user1, character: character1, status: 30) }

    let(:another_user2_stock_untrading1) { create(:stock, user: another_user2, character: character1, status: 0) }
    let(:another_user2_stock_untrading2) { create(:stock, user: another_user2, character: character2, status: 0) }
    let(:another_user2_stock_canceled) { create(:stock, user: another_user2, character: character1, status: 10) }
    let(:another_user2_stock_trading) { create(:stock, user: another_user2, character: character1, status: 20) }
    let(:another_user2_stock_traded) { create(:stock, user: another_user2, character: character1, status: 30) }

    before do
      user_stock_untrading
      user_stock_canceled
      user_stock_trading
      user_stock_traded

      another_user1_stock_untrading1
      another_user1_stock_untrading2
      another_user1_stock_untrading3
      another_user1_stock_canceled
      another_user1_stock_trading
      another_user1_stock_traded

      another_user2_stock_untrading1
      another_user2_stock_untrading2
      another_user2_stock_canceled
      another_user2_stock_trading
      another_user2_stock_traded
    end

    context 'when user wants has another user wants has no stock' do
      let(:want) { create(:want, user:, character: character3) }

      it 'returns empty array' do
        expect(want.candidate_stocks).to eq []
      end
    end

    context 'when user wants has another user wants has stock' do
      let(:want) { create(:want, user:, character: character1, status:) }

      shared_examples 'returns candidate stocks' do
        it 'returns candidate stocks' do
          expect(want.candidate_stocks).to eq(expected)
        end
      end

      context 'with wants status is untrading' do
        let(:status) { :untrading }
        let(:expected) do
          [another_user1_stock_untrading1, another_user1_stock_untrading2, another_user1_stock_untrading3,
           another_user2_stock_untrading1]
        end

        it_behaves_like 'returns candidate stocks'
      end

      context 'with wants status is canceled' do
        let(:status) { :canceled }
        let(:expected) { [] }

        it_behaves_like 'returns candidate stocks'
      end

      context 'with wants status is trading' do
        let(:status) { :trading }
        let(:expected) { [] }

        it_behaves_like 'returns candidate stocks'
      end

      context 'with wants status is traded' do
        let(:status) { :traded }
        let(:expected) { [] }

        it_behaves_like 'returns candidate stocks'
      end
    end
  end
end
