# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Dealings' do
  let(:headers) do
    {
      'Authorization' => "Bearer #{login(user.id)}",
    }
  end

  let(:applicant) { create(:user) }
  let(:partner) { create(:user, display_name: '別ユーザ') }
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

  describe 'POST /v1/dealings' do
    subject(:create_dealings) { post v1_dealings_path, params:, headers: }

    let(:user) { applicant }

    context 'when applicant applicate dealing' do
      context 'when concerned poeple are two' do
        let(:params) do
          {
            my_want_id: applicant_want1.id,
            your_stock_id: partner_stock1.id,
            your_want_id: partner_want1.id,
            my_stock_id: applicant_stock1.id,
          }
        end

        it 'returns 200' do
          create_dealings
          expect(response).to have_http_status(:ok)
        end

        it 'create two dealings' do
          expect do
            create_dealings
          end.to change {
                   Dealing.where(want_id: applicant_want1.id, stock_id: partner_stock1.id).count
                 }.from(0).to(1).and \
                   change {
                     Dealing.where(want_id: partner_want1.id, stock_id: applicant_stock1.id).count
                   }.from(0).to(1)
        end

        context 'but partner stock is already trading' do
          before { partner_stock1.update(status: :trading) }

          it 'returns 404' do
            create_dealings
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body['errors']).to eq({ 'message' => '状態が更新されてしまいました' })
          end
        end
      end
    end
  end

  describe 'PATCH /v1/dealings/:id/approve' do
    subject(:approve_dealings) { patch approve_v1_dealing_path(dealing.id), headers: }

    context 'when concerned people are two' do
      let(:dealing) { partner_dealing1 }

      before do
        applicant_dealing1
        partner_dealing1

        applicant_dealing1.update(dealing: partner_dealing1)
        partner_dealing1.update(dealing: applicant_dealing1)
      end

      context 'when partner approve dealing' do
        let(:user) { partner }

        it 'returns 200' do
          approve_dealings
          expect(response).to have_http_status(:ok)
        end

        it 'update dealing status to trading' do
          approve_dealings
          expect(applicant_dealing1.reload).to be_trading
          expect(partner_dealing1.reload).to be_trading
        end
      end

      # context 'when applicant approve dealing' do
      #   let(:user) { applicant }

      #   it 'returns 403' do
      #     approve_dealings
      #     expect(response).to have_http_status(:forbidden)
      #     expect(applicant_dealing1.reload).to be_application
      #     expect(partner_dealing1.reload).to be_application
      #   end
      # end
    end

    context 'when concerned people are three or more' do
      let(:dealing) { partner_dealing2 }

      before do
        applicant_dealing2
        partner_dealing2
        other_partner_dealing

        applicant_dealing2.update(dealing: other_partner_dealing)
        partner_dealing2.update(dealing: applicant_dealing2)
        other_partner_dealing.update(dealing: partner_dealing2)
      end

      context 'when partner approve dealing' do
        let(:user) { partner }

        it 'returns 200' do
          approve_dealings
          expect(response).to have_http_status(:ok)
        end

        context 'when all partner approve dealing' do
          it 'update all dealing status to trading' do
            other_partner_dealing.approve
            approve_dealings
            expect(applicant_dealing2.reload).to be_trading
            expect(partner_dealing2.reload).to be_trading
            expect(other_partner_dealing.reload).to be_trading
          end
        end

        context 'when all partner does not approve dealing' do
          it 'does not update dealing status to dealing' do
            approve_dealings
            expect(applicant_dealing2.reload).to be_application
            expect(partner_dealing2.reload).to be_approval
            expect(other_partner_dealing.reload).to be_application
          end
        end
      end
    end
  end

  describe 'DELETE /v1/dealings/:id' do
    subject(:deny_dealings) { delete v1_dealing_path(dealing.id), headers: }

    context 'when concerned people are two' do
      let(:dealing) { partner_dealing1 }

      before do
        applicant_dealing1
        partner_dealing1

        applicant_dealing1.update(dealing: partner_dealing1)
        partner_dealing1.update(dealing: applicant_dealing1)
      end

      context 'when partner deny dealing' do
        let(:user) { partner }

        it 'returns 200' do
          deny_dealings
          expect(response).to have_http_status(:ok)
        end

        it 'delete dealing' do
          deny_dealings
          expect(Dealing.count).to be_zero
          expect(applicant_want1.reload).to be_untrading
          expect(partner_stock1.reload).to be_untrading
          expect(partner_want1.reload).to be_untrading
          expect(applicant_stock1.reload).to be_untrading
        end
      end

      # context 'when applicant deny dealing' do
      #   let(:user) { applicant }

      #   it 'returns 403' do
      #     deny_dealings
      #     expect(response).to have_http_status(:forbidden)
      #   end
      # end
    end

    context 'when concerned people are three or more' do
      shared_examples 'deny dealing' do
        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'delete dealing and update want and stock status to untrading' do
          expect(Dealing.count).to be_zero
          expect(applicant_want2.reload).to be_untrading
          expect(other_partner_stock.reload).to be_untrading
          expect(partner_want2.reload).to be_untrading
          expect(applicant_stock2.reload).to be_untrading
          expect(other_partner_want.reload).to be_untrading
          expect(partner_stock2.reload).to be_untrading
        end
      end

      context 'when partner deny dealing' do
        let(:user) { partner }
        let(:dealing) { partner_dealing2 }

        context 'when no partner approve dealing' do
          before do
            applicant_dealing2
            partner_dealing2
            other_partner_dealing

            applicant_dealing2.update(dealing: other_partner_dealing)
            partner_dealing2.update(dealing: applicant_dealing2)
            other_partner_dealing.update(dealing: partner_dealing2)

            deny_dealings
          end

          it_behaves_like 'deny dealing'
        end

        context 'when other partner approve dealing' do
          before do
            applicant_dealing2
            partner_dealing2
            other_partner_dealing

            applicant_dealing2.update(dealing: other_partner_dealing)
            partner_dealing2.update(dealing: applicant_dealing2)
            other_partner_dealing.update(dealing: partner_dealing2)
            other_partner_dealing.approve

            deny_dealings
          end

          it_behaves_like 'deny dealing'
        end
      end
    end
  end
end
