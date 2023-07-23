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

  describe 'applicate' do
    subject(:applicatee) do
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
      expect { applicatee }.to change { described_class.all.count }.from(0).to(1)
      expect(applicatee.class).to eq(described_class)
      expect(applicatee).to be_application
    end

    it 'update want and stock status to trading' do
      applicatee
      expect(applicatee.applicant_want).to be_trading
      expect(applicatee.partner_stock).to be_trading
      expect(applicatee.partner_want).to be_trading
      expect(applicatee.applicant_stock).to be_trading
    end

    shared_examples 'status is not untrading' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect { applicatee }.to raise_error(ActiveRecord::RecordNotFound)
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
end
