# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dealing do
  let(:applicant) { create(:user) }
  let(:partner) { create(:user) }
  let(:other_partner) { create(:user) }

  let(:category) { create(:category) }
  let(:good) { create(:good, category:) }
  let(:character1) { create(:character, good:) }
  let(:character2) { create(:character, good:) }
  let(:character3) { create(:character, good:) }

  let(:applicant_want1) { create(:want, user: applicant, character: character1) }
  let(:applicant_stock1) { create(:stock, user: applicant, character: character2) }
  let(:partner_want1) { create(:want, user: partner, character: character2) }
  let(:partner_stock1) { create(:stock, user: partner, character: character1) }

  let(:applicant_dealing1) { create(:dealing, applicant:, want: applicant_want1, stock: partner_stock1) }
  let(:partner_dealing1) { create(:dealing, applicant:, want: partner_want1, stock: applicant_stock1) }

  let(:applicant_want2) { create(:want, user: applicant, character: character1) }
  let(:applicant_stock2) { create(:stock, user: applicant, character: character2) }
  let(:partner_want2) { create(:want, user: partner, character: character2) }
  let(:partner_stock2) { create(:stock, user: partner, character: character3) }
  let(:other_partner_want) { create(:want, user: partner, character: character3) }
  let(:other_partner_stock) { create(:stock, user: partner, character: character1) }

  let(:applicant_dealing2) { create(:dealing, applicant:, want: applicant_want2, stock: other_partner_stock) }
  let(:partner_dealing2) { create(:dealing, applicant:, want: partner_want2, stock: applicant_stock2) }
  let(:other_partner_dealing) { create(:dealing, applicant:, want: other_partner_want, stock: partner_stock2) }

  describe 'validations' do
    subject do
      build(
        :dealing,
        applicant:,
        want: applicant_want1,
        stock: partner_stock1,
        dealing: partner_dealing1,
        status: :application,
      )
    end

    it { is_expected.to be_valid }

    context 'when applicant is nil' do
      subject do
        build(
          :dealing,
          applicant: nil,
          want: nil,
          stock: partner_stock1,
          dealing: nil,
          status: :application,
        )
      end

      it { is_expected.to be_invalid }
    end

    context 'when want is nil' do
      subject do
        build(
          :dealing,
          applicant:,
          want: nil,
          stock: partner_stock1,
          dealing: nil,
          status: :application,
        )
      end

      it { is_expected.to be_invalid }
    end

    context 'when stock is nil' do
      subject do
        build(
          :dealing,
          applicant:,
          want: applicant_want1,
          stock: nil,
          dealing: nil,
          status: :application,
        )
      end

      it { is_expected.to be_invalid }
    end

    context 'when delaing is nil' do
      subject do
        build(
          :dealing,
          applicant:,
          want: applicant_want1,
          stock: partner_stock1,
          dealing: nil,
          status: :application,
        )
      end

      it { is_expected.to be_valid }
    end

    context 'when status is nil' do
      subject do
        build(
          :dealing,
          applicant:,
          want: applicant_want1,
          stock: partner_stock1,
          dealing: nil,
          status: nil,
        )
      end

      it { is_expected.to be_invalid }
    end
  end

  describe 'self.applicate' do
    subject(:applicate) do
      described_class.applicate(
        applicant,
        applicant,
        partner,
        applicant_want1.id,
        partner_stock1.id,
        nil,
      )
    end

    it 'insert dealing' do
      expect { applicate }.to change { described_class.all.count }.from(0).to(1)
      expect(applicate.class).to eq(described_class)
      expect(applicate).to be_application
    end

    it 'update want and stock status to trading' do
      applicate
      expect(applicate.want).to be_trading
      expect(applicate.stock).to be_trading
    end

    shared_examples 'status is not untrading' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect { applicate }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when applicant_want1 status is not untrading' do
      before { applicant_want1.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end

    context 'when partner_stock1 status is not untrading' do
      before { partner_stock1.update(status: :trading) }

      it_behaves_like 'status is not untrading'
    end
  end

  describe 'approve' do
    subject(:approve) { dealing.approve }

    context 'when concerned people are two' do
      let(:dealing) { partner_dealing1 }

      before do
        applicant_dealing1
        partner_dealing1

        applicant_dealing1.update(dealing: partner_dealing1)
        partner_dealing1.update(dealing: applicant_dealing1)
      end

      context 'when partner approve self dealing' do
        it 'update dealing status to trading' do
          approve
          expect(dealing.reload).to be_approval
        end

        it 'update want and stock status to trading' do
          approve
          dealing.reload
          expect(dealing.want).to be_traded
          expect(dealing.stock).to be_traded
        end
      end
    end

    # 三人以上の取引を実施できるようになったら、実施する
    # context 'when concerned people are three' do
    #   context "when other then partner approve partner's dealing" do
    #     let(:user) { applicant }

    #     it 'raise StandardError' do
    #       expect { approve }.to raise_error(StandardError)
    #     end
    #   end
    # end
  end

  describe 'deny' do
    subject(:deny) { dealing.deny }

    context 'when concerned people are two' do
      let(:dealing) { partner_dealing1 }

      before do
        applicant_dealing1
        partner_dealing1

        applicant_dealing1.update(dealing: partner_dealing1)
        partner_dealing1.update(dealing: applicant_dealing1)
      end

      context 'when partner deny self dealing' do
        it 'delete dealing' do
          expect { deny }.to change { described_class.all.size }.from(2).to(1)
        end

        it 'update want and stock status to trading' do
          deny
          expect(applicant_want1).to be_untrading
          expect(partner_stock1).to be_untrading
        end
      end
    end
  end

  describe 'dealings' do
    context 'when concerned dealing are two' do
      let(:expected_dealings) do
        [applicant_dealing1, partner_dealing1]
      end

      before do
        applicant_dealing1
        partner_dealing1

        applicant_dealing1.update(dealing: partner_dealing1)
        partner_dealing1.update(dealing: applicant_dealing1)
      end

      it 'return two dealings' do
        expect(applicant_dealing1.dealings).to match_array(expected_dealings)
        expect(partner_dealing1.dealings).to match_array(expected_dealings)
      end
    end

    context 'when concerned dealing are three' do
      let(:expected_dealings) do
        [
          applicant_dealing2,
          partner_dealing2,
          other_partner_dealing,
        ]
      end

      before do
        applicant_dealing2
        partner_dealing2
        other_partner_dealing

        applicant_dealing2.update(dealing: other_partner_dealing)
        partner_dealing2.update(dealing: applicant_dealing2)
        other_partner_dealing.update(dealing: partner_dealing2)
      end

      it 'return two dealings' do
        expect(applicant_dealing2.dealings).to match_array(expected_dealings)
        expect(partner_dealing2.dealings).to match_array(expected_dealings)
        expect(other_partner_dealing.dealings).to match_array(expected_dealings)
      end
    end
  end
end
