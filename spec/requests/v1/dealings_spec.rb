# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Dealings' do
  let(:headers) do
    {
      'Authorization' => "Bearer #{login(applicant.id)}",
    }
  end
  let(:applicant) { create(:user) }
  let(:partner) { create(:user, display_name: '別ユーザ') }
  let(:category) { create(:category) }
  let(:good) { create(:good, category:) }
  let(:character1) { create(:character, good:) }
  let(:character2) { create(:character, good:) }
  let(:applicant_want) { create(:want, user: applicant, character: character1) }
  let(:applicant_stock) { create(:stock, user: applicant, character: character2) }
  let(:partner_want) { create(:want, user: partner, character: character2) }
  let(:partner_stock) { create(:stock, user: partner, character: character1) }

  describe 'POST /v1/dealings' do
    subject(:create_dealings) { post v1_dealings_path, params:, headers: }

    context 'when applicant applicate dealing' do
      let(:params) do
        {
          my_want_id: applicant_want.id,
          your_stock_id: partner_stock.id,
          your_want_id: partner_want.id,
          my_stock_id: applicant_stock.id,
        }
      end

      it 'returns 200' do
        allow(Dealing).to receive(:applicate)
        create_dealings
        expect(response).to have_http_status(:ok)
        expect(Dealing).to have_received(:applicate).with(
          applicant.id,
          partner.id,
          applicant_want.id,
          partner_stock.id,
          partner_want.id,
          applicant_stock.id,
        )
      end

      context 'but partner stock is already trading' do
        before { partner_stock.update(status: :trading) }

        it 'returns 404' do
          create_dealings
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body['errors']).to eq({ 'message' => '状態が更新されてしまいました' })
        end
      end
    end
  end

  # pending "add some examples (or delete) #{__FILE__}"
end
