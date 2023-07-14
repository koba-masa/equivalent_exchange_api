# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VMatching do
  let(:category1) { create(:category) }
  let(:good1) { create(:good, category: category1) }
  let(:character1) { create(:character, good: good1) }
  let(:character2) { create(:character, good: good1) }
  let(:character3) { create(:character, good: good1) }
  let(:character4) { create(:character, good: good1) }

  let(:good2) { create(:good, category: category1) }
  let(:character5) { create(:character, good: good2) }
  let(:character6) { create(:character, good: good2) }
  let(:character7) { create(:character, good: good2) }

  let(:myself) { create(:user) }
  let(:my_want1) { create(:want, user: myself, character: character1) } # 複数人が在庫として持つ
  let(:my_want2) { create(:want, user: myself, character: character2) } # 1人が在庫として持つ
  let(:my_want3) { create(:want, user: myself, character: character3) } # 誰も在庫として持たない
  let(:my_stock1) { create(:stock, user: myself, character: character4) }

  let(:my_want4) { create(:want, user: myself, character: character5) } # 相手の欲しいものを持っていない
  let(:my_stock2) { create(:stock, user: myself, character: character7) }

  let(:yourself) { create(:user) }
  let(:your_want1) { create(:want, user: yourself, character: character4) }
  let(:your_stock1) { create(:stock, user: yourself, character: character1) }
  let(:your_want2) { create(:want, user: yourself, character: character6) }
  let(:your_stock2) { create(:stock, user: yourself, character: character5) }

  let(:otherself) { create(:user) }
  let(:other_want1) { create(:want, user: otherself, character: character4) }
  let(:other_stock1) { create(:stock, user: otherself, character: character1) }
  let(:other_stock2) { create(:stock, user: otherself, character: character2) }

  before do
    my_want1
    my_want2
    my_want3
    my_stock1
    my_want4
    my_stock2
    your_want1
    your_stock1
    your_want2
    your_stock2
    other_want1
    other_stock1
    other_stock2
  end

  describe 'self.candidate_matchings_by_want' do
    subject(:candidate_matchings_by_want) { described_class.candidate_matchings_by_want(myself.id, my_want_id) }

    shared_examples 'get no candidate matchings' do
      it do
        candidate_matchings_by_want
        expect(candidate_matchings_by_want.count).to eq 0
      end
    end

    context 'when one user has character i wants' do
      context 'with my having character other user wants' do
        let(:my_want_id) { my_want2.id }

        it 'get one candidate matchings' do
          candidate_matchings_by_want
          expect(candidate_matchings_by_want.count).to eq 1

          expect(candidate_matchings_by_want[0].your_user_id).to eq otherself.id
          expect(candidate_matchings_by_want[0].your_stock_id).to eq other_stock2.id
          expect(candidate_matchings_by_want[0].your_want_id).to eq other_want1.id
          expect(candidate_matchings_by_want[0].my_stock_id).to eq my_stock1.id
        end
      end

      context 'without my having character other user wants' do
        let(:my_want_id) { my_want4.id }

        it_behaves_like 'get no candidate matchings'
      end
    end

    context 'when multiple user has character i wants' do
      context 'with my having character other user wants' do
        let(:my_want_id) { my_want1.id }

        it 'get multiple candidate matchings' do
          candidate_matchings_by_want
          expect(candidate_matchings_by_want.count).to eq 2

          # FIXME: 何かよい方法はないだろうか
          i = 0
          j = 1
          if yourself.id > otherself.id
            i = 1
            j = 0
          end

          expect(candidate_matchings_by_want[i].your_user_id).to eq yourself.id
          expect(candidate_matchings_by_want[i].your_stock_id).to eq your_stock1.id
          expect(candidate_matchings_by_want[i].your_want_id).to eq your_want1.id
          expect(candidate_matchings_by_want[i].my_stock_id).to eq my_stock1.id

          expect(candidate_matchings_by_want[j].your_user_id).to eq otherself.id
          expect(candidate_matchings_by_want[j].your_stock_id).to eq other_stock1.id
          expect(candidate_matchings_by_want[j].your_want_id).to eq other_want1.id
          expect(candidate_matchings_by_want[j].my_stock_id).to eq my_stock1.id
        end
      end

      context 'without my having character other user wants' do
        let(:my_want_id) { my_want4.id }

        it_behaves_like 'get no candidate matchings'
      end
    end

    context 'when other user does not have character i wants' do
      let(:my_want_id) { my_want3.id }

      it_behaves_like 'get no candidate matchings'
    end
  end

  describe 'self.find_candidate_matching' do
    subject(:find_candidate_matching) do
      described_class.find_candidate_matching(my_user_id, my_want_id, your_stock_id, your_want_id, my_stock_id)
    end

    let(:my_user_id) { myself.id }
    let(:my_want_id) { my_want2.id }
    let(:your_stock_id) { other_stock2.id }
    let(:your_want_id) { other_want1.id }
    let(:my_stock_id) { my_stock1.id }

    context 'when candidate matching exists' do
      it 'return candidate matching' do
        result = find_candidate_matching
        expect(result).not_to be_nil
        expect(result.your_user_id).to eq otherself.id
        expect(result.your_stock_id).to eq other_stock2.id
        expect(result.your_want_id).to eq other_want1.id
        expect(result.my_stock_id).to eq my_stock1.id
      end
    end

    context 'when candidate matching does not exist' do
      let(:your_stock_id) { 0 }

      it 'return nil' do
        expect(find_candidate_matching).to be_nil
      end
    end
  end
end
