# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Good do
  describe 'validation' do
    subject { build(:good) }

    it { is_expected.to be_valid }

    context 'when category is nil' do
      subject { build(:good, category: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when name is nil' do
      subject { build(:good, name: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when name is too long' do
      subject { build(:good, name: 'a' * 129) }

      it { is_expected.to be_invalid }
    end

    context 'when name is not unique in category' do
      subject { build(:good, category:, name: good.name) }

      let(:category) { create(:category) }
      let(:good) { create(:good, category:) }

      it { is_expected.to be_invalid }
    end
  end
end
