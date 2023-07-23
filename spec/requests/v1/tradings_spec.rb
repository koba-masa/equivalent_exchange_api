# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Tradings' do
  let(:user) { create(:user, display_name: 'テスト用ユーザ') }
  let(:another_user) { create(:user, display_name: '別ユーザ') }
  let(:category1) { create(:category, name: 'カテゴリ1') }
  let(:category2) { create(:category, name: 'カテゴリ2') }
  let(:good1) { create(:good, name: 'グッズ1', category: category1) }
  let(:good2) { create(:good, name: 'グッズ2', category: category2) }
  let(:character1) { create(:character, name: 'キャラクター1', good: good1) }
  let(:character2) { create(:character, name: 'キャラクター2', good: good1) }
  let(:character3) { create(:character, name: 'キャラクター3', good: good2) }
  let(:character4) { create(:character, name: 'キャラクター4', good: good2) }

  describe 'POST /v1/tradings' do
    subject(:create_tradings) { post v1_tradings_path, params: }

    let(:my_want) { create(:want, user:, character: character2, status: :untrading) }
    let(:my_stock) { create(:stock, user:, character: character1, status: :untrading) }
    let(:your_want) { create(:want, user: another_user, character: character1, status: :untrading) }
    let(:your_stock_untrading) { create(:stock, user: another_user, character: character2, status: :untrading) }
    let(:your_stock_trading) { create(:stock, user: another_user, character: character2, status: :trading) }

    before do
      my_want
      my_stock
      your_want
      your_stock_untrading
      your_stock_trading
    end

    shared_examples 'can not lock record' do
      it do
        allow(VMatching).to receive(:find_candidate_matching).and_wrap_original do |method, *args|
          original_result = method.call(*args)
          Stock.find_by(id: stock.id).update(status: :trading)
          original_result
        end
        create_tradings
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors']).to eq({ 'message' => '状態が更新されてしまいました' })
      end
    end

    context 'when applicating' do
      context 'with matching exists' do
        let(:params) do
          {
            user_id: user.id,
            my_want_id: my_want.id,
            your_stock_id: your_stock_untrading.id,
            your_want_id: your_want.id,
            my_stock_id: my_stock.id,
          }
        end

        it 'returns ok' do
          create_tradings
          expect(response).to have_http_status(:ok)
          my_trading = Trading.find_by(want: my_want, stock: your_stock_untrading)
          your_trading = Trading.find_by(want: your_want, stock: my_stock)
          expect(my_trading).to be_present
          expect(my_trading.trading).to eq(your_trading)
          expect(your_trading).to be_present
          expect(your_trading.trading).to eq(my_trading)
          expect(my_want.reload).to be_trading
          expect(my_stock.reload).to be_trading
          expect(your_stock_untrading.reload).to be_trading
          expect(your_want.reload).to be_trading
        end

        context 'but updated your stock' do
          let(:params) do
            {
              user_id: user.id,
              my_want_id: my_want.id,
              your_stock_id: your_stock_untrading.id,
              your_want_id: your_want.id,
              my_stock_id: my_stock.id,
            }
          end
          let(:stock) { your_stock_untrading }

          it_behaves_like 'can not lock record'
        end

        context 'but updated my stock' do
          let(:params) do
            {
              user_id: user.id,
              my_want_id: my_want.id,
              your_stock_id: your_stock_untrading.id,
              your_want_id: your_want.id,
              my_stock_id: my_stock.id,
            }
          end
          let(:stock) { my_stock }

          it_behaves_like 'can not lock record'
        end
      end

      context 'with matching does not exist' do
        let(:params) do
          {
            user_id: user.id,
            my_want_id: my_want.id,
            your_stock_id: your_stock_trading.id,
            your_want_id: your_want.id,
            my_stock_id: my_stock.id,
          }
        end

        it 'returns not_found' do
          create_tradings
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body['errors']).to eq({})
        end
      end
    end
  end

  describe 'PATCH /v1/tradings/:id' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
