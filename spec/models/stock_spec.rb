# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock do
  describe 'validations' do
    subject { build(:stock) }

    it { is_expected.to be_valid }

    context 'when user is nil' do
      subject { build(:stock, user: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when character is nil' do
      subject { build(:stock, character: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when status is nil' do
      subject { build(:stock, status: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when image is nil' do
      subject { build(:stock, image: nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'image_url' do
    let(:stock) { build(:stock, image: 'sample.png') }

    it 'returns image url' do
      expect(stock.image_url).to eq 'http://localhost:3000/stocks/image/sample.png'
    end
  end
end
