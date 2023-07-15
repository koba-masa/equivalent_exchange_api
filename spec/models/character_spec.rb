# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character do
  describe 'validation' do
    subject { build(:character) }

    it { is_expected.to be_valid }

    context 'when goods is nil' do
      subject { build(:character, good: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when name is nil' do
      subject { build(:character, name: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when name is too long' do
      subject { build(:character, name: 'a' * 129) }

      it { is_expected.to be_invalid }
    end

    context 'when character is not unique in good' do
      subject { build(:character, good:, name: '商品') }

      let(:good) { create(:good) }
      let(:character) { create(:character, good:, name: '商品') }

      before { character }

      it { is_expected.to be_invalid }
    end
  end
end
