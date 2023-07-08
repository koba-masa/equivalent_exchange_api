# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Category::Good::Characters' do
  describe 'GET /v1/categories/:category_id/goods/:good_id/characters' do
    subject(:get_characters) { get v1_category_good_characters_path(category_id:, good_id:) }

    let(:category) { create(:category) }
    let(:good) { create(:good, category:) }

    shared_examples 'get characters' do
      it do
        get_characters
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when there are no characters' do
      let(:expected_response) { { 'characters' => [] } }
      let(:category_id) { category.id }
      let(:good_id) { good.id }

      it_behaves_like 'get characters'
    end

    context 'when the good does not exist' do
      let(:expected_response) { { 'characters' => [] } }
      let(:category_id) { category.id }
      let(:good_id) { 0 }

      it_behaves_like 'get characters'
    end

    context 'when the category does not exist' do
      let(:expected_response) { { 'characters' => [] } }
      let(:category_id) { 0 }
      let(:good_id) { 0 }

      it_behaves_like 'get characters'
    end

    context 'when there are characters' do
      let(:expected_response) do
        {
          'characters' => [
            { 'category_id' => category.id, 'category_name' => category.name, 'good_id' => good.id,
              'good_name' => good.name, 'id' => character2.id, 'name' => character2.name },
            { 'category_id' => category.id, 'category_name' => category.name, 'good_id' => good.id,
              'good_name' => good.name, 'id' => character1.id, 'name' => character1.name },
          ],
        }
      end
      let(:category_id) { category.id }
      let(:good_id) { good.id }
      let(:character1) { create(:character, good:, name: 'キャラクターB') }
      let(:character2) { create(:character, good:, name: 'キャラクターA') }

      before do
        character1
        character2
      end

      it_behaves_like 'get characters'
    end

    context 'when there are characters and the category and goods are not in the same combination' do
      let(:expected_response) { { 'characters' => [] } }
      let(:category_id) { 0 }
      let(:good_id) { good.id }
      let(:another_good) { create(:good, category:, name: '別商品') }
      let(:character1) { create(:character, good:, name: 'キャラクターB') }
      let(:character2) { create(:character, good:, name: 'キャラクターA') }
      let(:character3) { create(:character, good: another_good, name: 'キャラクターA') }

      before do
        character1
        character2
        character3
      end

      it_behaves_like 'get characters'
    end
  end

  describe 'POST /v1/categories/:category_id/goods/:good_id/characters' do
    subject(:create_characters) { post v1_category_good_characters_path(category_id:, good_id:), params: }

    let(:category) { create(:category) }
    let(:good) { create(:good, category:) }
    let(:params) { { character: { name: 'キャラクターA' } } }

    context 'when the character does not exist' do
      let(:category_id) { category.id }
      let(:good_id) { good.id }

      it 'returns the created character' do
        create_characters
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['name']).to eq('キャラクターA')
      end
    end

    context 'when the good does not exist' do
      let(:category_id) { category.id }
      let(:good_id) { 0 }

      it 'returns the error' do
        create_characters
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['good']).to eq(['does not exist'])
      end
    end

    context 'when the category does not exist' do
      let(:category_id) { 0 }
      let(:good_id) { good.id }

      it 'returns the error' do
        create_characters
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['good']).to eq(['does not exist'])
      end
    end

    context 'when the character already exists' do
      let(:category_id) { category.id }
      let(:good_id) { good.id }
      let(:character) { create(:character, good:, name: 'キャラクターA') }

      before { character }

      it 'returns the error' do
        create_characters
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['name']).to eq(['has already been taken'])
      end
    end

    context 'when there are characters and the category and goods are not in the same combination' do
      let(:another_category) { create(:category, name: '別カテゴリー') }
      let(:category_id) { another_category.id }
      let(:good_id) { good.id }

      it 'returns the error' do
        create_characters
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['good']).to eq(['does not exist'])
      end
    end
  end
end
