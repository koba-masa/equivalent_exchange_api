# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dealing do
  let(:applicant) { create(:user) }
  let(:partner) { create(:user) }

  let(:category) { create(:category) }
  let(:good) { create(:good, category:) }
  let(:character1) { create(:character, good:) }
  let(:character2) { create(:character, good:) }

  let(:applicant_want) { create(:want, user: applicant, character: character1) }
  let(:applicant_stock) { create(:stock, user: applicant, character: character2) }
  let(:partner_want) { create(:want, user: partner, character: character2) }
  let(:partner_stock) { create(:stock, user: partner, character: character1) }

  describe 'validations' do
    subject do
      build(
        :dealing,
        applicant_want:,
        partner_stock:,
        partner_want:,
        applicant_stock:,
      )
    end

    it { is_expected.to be_valid }

    context 'when applicant_want is nil' do
      let(:applicant_want) { nil }

      it { is_expected.to be_invalid }
    end

    context 'when partner_stock is nil' do
      let(:partner_stock) { nil }

      it { is_expected.to be_invalid }
    end

    context 'when partner_want is nil' do
      let(:partner_want) { nil }

      it { is_expected.to be_invalid }
    end

    context 'when applicant_stock is nil' do
      let(:applicant_stock) { nil }

      it { is_expected.to be_invalid }
    end

    context 'when status is nil' do
      subject { build(:dealing, status: nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'self.applicate' do
    subject(:applicate) do
      described_class.applicate(
        applicant,
        partner,
        applicant_want.id,
        partner_stock.id,
        partner_want.id,
        applicant_stock.id,
      )
    end

    it 'insert dealing' do
      expect { applicate }.to change { described_class.all.count }.from(0).to(1)
      expect(applicate.class).to eq(described_class)
      expect(applicate).to be_application
    end

    it 'update want and stock status to trading' do
      applicate
      expect(applicate.applicant_want).to be_trading
      expect(applicate.partner_stock).to be_trading
      expect(applicate.partner_want).to be_trading
      expect(applicate.applicant_stock).to be_trading
    end

    shared_examples 'status is not untrading' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect { applicate }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when applicant_want status is not untrading' do
      before { applicant_want.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end

    context 'when partner_stock status is not untrading' do
      before { partner_stock.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end

    context 'when partner_want status is not untrading' do
      before { partner_want.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end

    context 'when applicant_stock status is not untrading' do
      before { applicant_stock.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end
  end

  describe 'approve' do
    subject(:approve) { dealing.approve(user) }

    let(:dealing) do
      create(
        :dealing,
        applicant_want:,
        partner_stock:,
        partner_want:,
        applicant_stock:,
      )
    end

    context 'when partner approve dealing' do
      let(:user) { partner }

      it 'update dealing status to trading' do
        approve
        expect(dealing.reload).to be_approval
      end

      it 'update want and stock status to trading' do
        approve
        dealing.reload
        expect(dealing.applicant_want).to be_traded
        expect(dealing.partner_stock).to be_traded
        expect(dealing.partner_want).to be_traded
        expect(dealing.applicant_stock).to be_traded
      end
    end

    context 'when other then partner approve dealing' do
      let(:user) { applicant }

      it 'raise StandardError' do
        expect { approve }.to raise_error(StandardError)
      end
    end
  end

  describe 'deny' do
    subject(:deny) { dealing.deny(user) }

    let(:dealing) do
      create(
        :dealing,
        applicant_want:,
        partner_stock:,
        partner_want:,
        applicant_stock:,
      )
    end

    before { dealing }

    context 'when partner approve dealing' do
      let(:user) { partner }

      it 'update dealing status to trading' do
        expect { deny }.to change { described_class.all.size }.from(1).to(0)
      end

      it 'update want and stock status to trading' do
        deny
        expect(applicant_want).to be_untrading
        expect(partner_stock).to be_untrading
        expect(partner_want).to be_untrading
        expect(applicant_stock).to be_untrading
      end
    end

    context 'when other then partner approve dealing' do
      let(:user) { applicant }

      it 'raise StandardError' do
        expect { deny }.to raise_error(StandardError)
      end
    end
  end
end
