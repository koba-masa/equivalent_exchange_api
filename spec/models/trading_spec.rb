# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trading do
  let(:myself) { create(:user) }
  let(:yourself) { create(:user) }

  let(:category) { create(:category) }
  let(:good) { create(:good, category:) }
  let(:character1) { create(:character, good:) }
  let(:character2) { create(:character, good:) }

  let(:my_want) { create(:want, user: myself, character: character1) }
  let(:my_stock) { create(:stock, user: myself, character: character2) }
  let(:your_want) { create(:want, user: yourself, character: character2) }
  let(:your_stock) { create(:stock, user: yourself, character: character1) }

  describe 'validations' do
    subject { build(:trading) }

    it { is_expected.to be_valid }

    context 'when want is nil' do
      subject { build(:trading, want: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when stock is nil' do
      subject { build(:trading, stock: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when status is nil' do
      subject { build(:trading, status: nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'callbacks' do
    before do
      my_want
      my_stock
      your_want
      your_stock
    end

    context 'when before_save' do
      subject(:save_trading) do
        trading = described_class.new(want: my_want, stock: your_stock)
        trading.save
      end

      it 'insert trading' do
        expect { save_trading }.to change { described_class.all.count }.from(0).to(1)
      end

      it 'update wnat and stock status to trading' do
        save_trading
        expect(my_want).to be_trading
        expect(your_stock).to be_trading
      end
    end

    context 'when before_create' do
      subject(:create_trading) do
        described_class.create(want: my_want, stock: your_stock)
      end

      it 'insert trading' do
        expect { create_trading }.to change { described_class.all.count }.from(0).to(1)
      end

      it 'update wnat and stock status to trading' do
        create_trading
        expect(my_want).to be_trading
        expect(your_stock).to be_trading
      end
    end

    context 'when before_update' do
      context 'with updating status to traded' do
        subject(:update_trading) do
          traging.update(status: :traded)
        end

        let!(:traging) { create(:trading, want: my_want, stock: your_stock) }

        it 'update trading status to traded' do
          update_trading
          expect(traging).to be_traded
        end

        it 'update wnat and stock status to traded' do
          update_trading
          expect(my_want).to be_traded
          expect(your_stock).to be_traded
        end
      end

      context 'with updating other than status' do
        pending "add some examples (or delete) #{__FILE__}"
      end
    end

    context 'when before_destroy' do
      subject(:destroy_trading) do
        traging.destroy
      end

      let!(:traging) { create(:trading, want: my_want, stock: your_stock) }

      it 'update trading status to traded' do
        expect { destroy_trading }.to change { described_class.all.count }.from(1).to(0)
      end

      it 'update wnat and stock status to traded' do
        destroy_trading
        expect(my_want).to be_untrading
        expect(your_stock).to be_untrading
      end
    end
  end
end
